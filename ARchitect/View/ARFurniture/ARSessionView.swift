import SwiftUI
import RealityKit
import ARKit
struct ARSessionView: View {
    @State private var scaleFactor: Float = 1.0
    @State private var arView = ARView(frame: .zero)
    @State private var showMenu = false
    
    let colors: [(name: String, color: UIColor)] = [
        ("Gray", .gray),
        ("Red", .red),
        ("Green", .green),
        ("Blue", .blue),
        ("Yellow", .yellow)
    ]
    
    var body: some View {
        ZStack {
            ARViewContainer(arView: $arView, scaleFactor: $scaleFactor)
                .edgesIgnoringSafeArea(.all)
            
            if showMenu {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select Cube Color:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    ForEach(colors, id: \.name) { color in
                        Button(action: {
                            addCube(color: color.color)
                        }) {
                            HStack {
                                Rectangle()
                                    .fill(Color(color.color))
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(8)
                                
                                Text(color.name)
                                    .foregroundColor(.white)
                                    .font(.body)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: 200)
                .background(Color.black.opacity(0.8))
                .cornerRadius(15)
                .padding()
                .transition(.move(edge: .leading))
            }
            
            // Menu Button
            Button(action: {
                withAnimation {
                    showMenu.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
            }
            .position(x: 30, y: 50)
        }
    }
    
    func addCube(color: UIColor) {
        let model = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: color, isMetallic: false)])
        model.name = "Cube"
        model.position = [Float.random(in: -0.3...0.3), 0.05, Float.random(in: -0.3...0.3)]
        model.generateCollisionShapes(recursive: true)
        
        let infoBox = createInfoBox(color: color)
        infoBox.position = SIMD3<Float>(0, 0.12, 0)
        model.addChild(infoBox)
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(model)
        arView.scene.anchors.append(anchor)
    }
}
struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView
    @Binding var scaleFactor: Float
    
    func makeUIView(context: Context) -> ARView {
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = [.horizontal]
        arView.session.run(arConfiguration)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        for entity in uiView.scene.anchors.flatMap({ $0.children }) {
            if let model = entity as? ModelEntity {
                model.scale = SIMD3<Float>(scaleFactor, scaleFactor, scaleFactor)
            }
        }
    }
}
func createInfoBox(color: UIColor) -> Entity {
    let textMesh = MeshResource.generateText(
        "Cube Info\nColor: \(color.accessibilityName)\nSize: 0.10m",
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

