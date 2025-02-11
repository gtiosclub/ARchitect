import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var isEnlarged = false
    @State private var scaleFactor : Float = 1.0
    @State private var selectedEntity: Entity? 

    var body: some View {
        ZStack {
            RealityView { content in
                
                // Create a cube model
                let model = Entity()
                let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
                let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
                model.components.set(ModelComponent(mesh: mesh, materials: [material]))
                model.position = [0, 0.05, 0]
                
                // Create horizontal plane anchor for the content
                let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
                anchor.addChild(model)
                
                // Add the horizontal plane anchor to the scene
                content.add(anchor)
                
                content.camera = .spatialTracking
                
                // Store the created model for future use
                self.selectedEntity = model
            } update: { content in
                // Adjust scale based on scale factor
                content.entities.first?.scale = .one * SIMD3<Float>(self.scaleFactor, self.scaleFactor, self.scaleFactor)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Only move the cube if it's selected
                        if let model = self.selectedEntity {
                            let translation = value.translation
                            moveObject(model, withTranslation: translation)
                        }
                    }
            )
            
            VStack {
                Spacer()
                HStack {
                    // Enlarge Button
                    Button {
                        if scaleFactor < 2.0 { // Prevent it from enlarging indefinitely
                            scaleFactor += 0.5
                        }
                    } label: {
                        Text("Enlarge the Cube")
                    }
                    .padding()

                    // Shrink Button
                    Button {
                        if scaleFactor > 0.5 { // Prevent shrinking below a minimum size
                            scaleFactor -= 0.5
                        }
                    } label: {
                        Text("Shrink the Cube")
                    }
                    .padding()
                }
                Spacer().frame(height: 30)
            }
            .padding(.bottom, 50)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // Function to move the object based on drag translation
    func moveObject(_ object: Entity, withTranslation translation: CGSize) {
        let scalingFactor: Float = 0.001 // Slow down movement further
        let translationInARSpace = SIMD3<Float>(
            Float(translation.width) * scalingFactor,
            0,
            Float(translation.height) * scalingFactor
        )
        object.position += translationInARSpace
    }
}

#Preview {
    ContentView()
}
