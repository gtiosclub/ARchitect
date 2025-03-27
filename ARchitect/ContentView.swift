import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var anchor: AnchorEntity?
    @State private var rotation: Float = 0.0
    @State private var scale: Float = 1.0

    var body: some View {
        RealityView { content in
            var sneakerModel: ModelEntity?

            do {
                sneakerModel = try await ModelEntity(named: "sneaker_airforce")
            } catch {
                print("Failed to import model")
            }

            let newAnchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))

            if let sneakerModel = sneakerModel {
                sneakerModel.generateCollisionShapes(recursive: true)
                sneakerModel.components.set(InputTargetComponent())
                sneakerModel.transform.scale = SIMD3<Float>(repeating: scale)
                newAnchor.addChild(sneakerModel)
            }

            content.add(newAnchor)
            content.camera = .spatialTracking

            DispatchQueue.main.async {
                self.anchor = newAnchor
            }
        }
        .gesture(
            RotationGesture()
                .onChanged { angle in
                    guard let model = anchor?.children.first as? ModelEntity else { return }
                    model.transform.rotation = simd_quatf(angle: rotation + Float(angle.radians), axis: [0, 1, 0])
                }
                .onEnded { angle in
                    rotation += Float(angle.radians)
                }
        )
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    guard let model = anchor?.children.first as? ModelEntity else { return }
                    let newScale = scale * Float(value)
                    model.transform.scale = SIMD3<Float>(repeating: newScale)
                }
                .onEnded { value in
                    scale *= Float(value)
                }
        )
    }
}
