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
        
        // Create info box entity
        let infoBox = createInfoBox()
        infoBox.position = SIMD3<Float>(0, 0.1, 0) // Position the info box directly on top of the cube
        model.addChild(infoBox)
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(model)
        arView.scene.anchors.append(anchor)
        
        context.coordinator.model = model
        context.coordinator.anchor = anchor
        
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
    
    class Coordinator {
        var parent: ARViewContainer
        var model: ModelEntity?
        var anchor: AnchorEntity?
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
    }
    
    // Helper function to create the info box entity
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
        let textMaterial = SimpleMaterial(color: .black, isMetallic: false) // Black text
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5) // Scale down the text
        
        // Calculate the size of the text bounding box
        let textBounds = textMesh.bounds
        let textWidth = textBounds.max.x - textBounds.min.x
        let textHeight = textBounds.max.y - textBounds.min.y
        
        // Create a white box behind the text
        let boxMesh = MeshResource.generateBox(size: [textWidth * 0.6, textHeight * 0.6, 0.01]) // Adjust size to fit the text
        let boxMaterial = SimpleMaterial(color: .white, isMetallic: false) // White box
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        boxEntity.position = [0, 0, -0.005] // Position the box slightly behind the text
        
        // Center the text within the box
        let textOffsetX = -textBounds.center.x * 0.5 // Adjust for text scaling
        let textOffsetY = -textBounds.center.y * 0.5 // Adjust for text scaling
        textEntity.position = [textOffsetX, textOffsetY, 0.005] // Position the text slightly in front of the box
        
        // Create a parent entity to hold both the text and the box
        let infoBoxEntity = Entity()
        infoBoxEntity.addChild(boxEntity)
        infoBoxEntity.addChild(textEntity)
        
        return infoBoxEntity
    }
}

#Preview {
    ARSessionView()
}
