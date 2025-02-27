import SwiftUI
import RealityKit
import ARKit

struct ARSessionView: View {
    @State private var scaleFactor: Float = 1.0
    @State private var arView = ARView(frame: .zero)
    
    var body: some View {
        ZStack {
            ARViewContainer(arView: $arView, scaleFactor: $scaleFactor)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Button {
                    self.scaleFactor *= 2
                } label: {
                    Text("Enlarge the cube")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
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
    @Binding var scaleFactor: Float
    
    func makeUIView(context: Context) -> ARView {
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = [.horizontal]
        arView.session.run(arConfiguration)
        
        // Create cube model
        let model = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .gray, isMetallic: true)])
        model.name = "Cube"
        model.position = [0, 0.05, 0]
        model.generateCollisionShapes(recursive: true)
        
        // Create info box entity
        let infoBox = createInfoBox()
        infoBox.position = SIMD3<Float>(0, 0.1, 0)
        model.addChild(infoBox)
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(model)
        arView.scene.anchors.append(anchor)
        
        // Add gesture recognizers
        let panGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        arView.addGestureRecognizer(panGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        arView.addGestureRecognizer(pinchGestureRecognizer)
        
        // Set up coordinator
        context.coordinator.arView = arView
        context.coordinator.model = model
        context.coordinator.anchor = anchor
        context.coordinator.selectedEntity = model
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = context.coordinator.model {
            model.scale = SIMD3<Float>(scaleFactor, scaleFactor, scaleFactor)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        weak var arView: ARView?
        var model: ModelEntity?
        var anchor: AnchorEntity?
        var selectedEntity: ModelEntity?
        var lastWorldPosition: SIMD3<Float>?
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let arView = arView, let entity = selectedEntity else { return }
            
            let touchLocation = gesture.location(in: arView)
            let hitTestResults = arView.raycast(from: touchLocation, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let firstResult = hitTestResults.first {
                let worldPosition = SIMD3<Float>(firstResult.worldTransform.columns.3.x,
                                               firstResult.worldTransform.columns.3.y,
                                               firstResult.worldTransform.columns.3.z)
                
                if gesture.state == .began {
                    lastWorldPosition = worldPosition
                } else if gesture.state == .changed, let lastPosition = lastWorldPosition {
                    let translation = worldPosition - lastPosition
                    entity.position += translation
                    lastWorldPosition = worldPosition
                }
            }
        }
        
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let entity = selectedEntity else { return }
            
            if gesture.state == .changed {
                parent.scaleFactor *= Float(gesture.scale)
                gesture.scale = 1.0
            }
        }
    }
    
    private func createInfoBox() -> Entity {
        // Create the text
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
        
        // Calculate the size of the text bounding box
        let textBounds = textMesh.bounds
        let textWidth = textBounds.max.x - textBounds.min.x
        let textHeight = textBounds.max.y - textBounds.min.y
        
        // Create a white box behind the text
        let boxMesh = MeshResource.generateBox(size: [textWidth * 0.6, textHeight * 0.6, 0.01])
        let boxMaterial = SimpleMaterial(color: .white, isMetallic: false)
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        boxEntity.position = [0, 0, -0.005]
        
        // Center the text within the box
        let textOffsetX = -textBounds.center.x * 0.5
        let textOffsetY = -textBounds.center.y * 0.5
        textEntity.position = [textOffsetX, textOffsetY, 0.005]
        
        // Create a parent entity to hold both the text and the box
        let infoBoxEntity = Entity()
        infoBoxEntity.addChild(boxEntity)
        infoBoxEntity.addChild(textEntity)
        
        return infoBoxEntity
    }
}
