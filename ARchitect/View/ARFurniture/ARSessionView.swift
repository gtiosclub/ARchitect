import SwiftUI
import RealityKit
import ARKit

struct ARSessionView: View {
    @State private var arView = ARView(frame: .zero)
    @State private var addCubeTrigger = false
    
    var body: some View {
        ZStack {
            ARViewContainer(arView: $arView,
                            addCubeTrigger: $addCubeTrigger)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Button {
                    addCubeTrigger = true
                } label: {
                    Text("Add Cube")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView
    @Binding var addCubeTrigger: Bool
    
    func makeUIView(context: Context) -> ARView {
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = [.horizontal]
        arView.session.run(arConfiguration)
        
        // Create a horizontal anchor for the scene.
        let anchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(anchor)
        context.coordinator.arView = arView
        context.coordinator.anchor = anchor
        
        // Add the first cube.
        context.coordinator.addCube()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // When triggered, add a new cube.
        if addCubeTrigger {
            context.coordinator.addCube()
            addCubeTrigger = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        weak var arView: ARView?
        var anchor: AnchorEntity?
        var cubeCount: Int = 0
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        /// Adds a new cube (with its own info box) to the scene and installs built-in gestures.
        func addCube() {
            guard let anchor = anchor, let arView = arView else { return }
            
            // Offset each cube slightly to avoid overlap.
            let offset: Float = Float(cubeCount) * 0.15
            let newCube = ModelEntity(mesh: .generateBox(size: 0.1),
                                      materials: [SimpleMaterial(color: .gray, isMetallic: true)])
            newCube.name = "Cube \(cubeCount + 1)"
            newCube.position = [offset, 0.05, 0]
            newCube.generateCollisionShapes(recursive: true)
            
            // Create and attach the info box.
            let infoBox = ARViewContainer.createInfoBox()
            infoBox.position = SIMD3<Float>(0, 0.1, 0)
            newCube.addChild(infoBox)
            
            // Add the cube to the anchor.
            anchor.addChild(newCube)
            
            // Install built-in gestures for translation, rotation, and scaling.
            arView.installGestures([.translation, .rotation, .scale], for: newCube)
            
            cubeCount += 1
        }
    }
    
    /// Helper method to create an info box for a cube.
    static func createInfoBox() -> Entity {
        let textMesh = MeshResource.generateText(
            "Cube Info\nColor: Gray\nSize: 0.10m",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.03),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        )
        let textMaterial = SimpleMaterial(color: .black, isMetallic: false)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
        
        let textBounds = textMesh.bounds
        let textWidth = textBounds.max.x - textBounds.min.x
        let textHeight = textBounds.max.y - textBounds.min.y
        
        let boxMesh = MeshResource.generateBox(size: [textWidth * 0.6, textHeight * 0.6, 0.01])
        let boxMaterial = SimpleMaterial(color: .white, isMetallic: false)
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        boxEntity.position = [0, 0, -0.005]
        
        let textOffsetX = -textBounds.center.x * 0.5
        let textOffsetY = -textBounds.center.y * 0.5
        textEntity.position = [textOffsetX, textOffsetY, 0.005]
        
        let infoBoxEntity = Entity()
        infoBoxEntity.addChild(boxEntity)
        infoBoxEntity.addChild(textEntity)
        
        return infoBoxEntity
    }
}
