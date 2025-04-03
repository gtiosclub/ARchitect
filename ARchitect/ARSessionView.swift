import SwiftUI
import RealityKit
import ARKit

struct ARSessionView: View {
    @State private var scaleFactor: Float = 1.0
    @State private var arView = ARView(frame: .zero)
    @State private var selectedModel: String? // Track the selected model
    let furnitureModels = ["GreyCouch", "modern chair"] // Available models

    var body: some View {
        HStack {
            // Sidebar for model selection
            List(furnitureModels, id: \.self) { model in
                Button(action: {
                    selectedModel = model
                }) {
                    Text(model)
                }
            }
            .frame(width: 150) // Sidebar width

            // AR View
            ZStack {
                ARViewContainer(arView: $arView, scaleFactor: $scaleFactor, selectedModel: $selectedModel)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    Button {
                        self.scaleFactor *= 2
                    } label: {
                        Text("Enlarge Model")
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
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView
    @Binding var scaleFactor: Float
    @Binding var selectedModel: String? // Bind the selected model

    func makeUIView(context: Context) -> ARView {
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = [.horizontal]
        arView.session.run(arConfiguration)

        // Set up coordinator
        context.coordinator.arView = arView

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = selectedModel {
            // Load and place the selected model
            if let modelEntity = try? ModelEntity.load(named: modelName) {
                modelEntity.name = modelName
                modelEntity.position = [0, 0.05, 0]
                modelEntity.generateCollisionShapes(recursive: true)

                let anchor = AnchorEntity(plane: .horizontal)
                anchor.addChild(modelEntity)
                arView.scene.anchors.append(anchor)

                // Reset the selected model to avoid re-adding
                DispatchQueue.main.async {
                    selectedModel = nil
                }
            }
        }

        // Update scale factor
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

        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
    }
}
