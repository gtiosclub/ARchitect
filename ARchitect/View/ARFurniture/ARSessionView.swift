//
//  ARSessionView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 11/02/25.
//

import SwiftUI
import RealityKit

struct ARSessionView: View {
    
    @State private var scaleFactor: Float = 1.0
    
    // The base position of the cube.
    @State private var cubeBasePosition: SIMD3<Float> = [0, 0.05, 0]
    
    // The temporary drag offset (in screen points, later converted to meters).
    @State private var dragOffset: CGSize = .zero
    
    // A state variable to toggle the highlight.
    @State private var isHighlighted: Bool = false
    
    // A temporary vertical offset coming from the pinch (magnification) gesture.
    @State private var pinchVerticalOffset: Float = 0.0

    var body: some View {
        ZStack {
            RealityView { content in
                // --- Make Closure: draws the initial content provided below ---
                
                /*
                    - Step 1: Define all entities here
                       - In this case we only have one cube entity
                 */
                let boxSize = SIMD3<Float>(0.1, 0.1, 0.1)
                let cube = ModelEntity(
                    mesh: MeshResource.generateBox(size: boxSize),
                    materials: [SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)]
                )
                
                
                /*
                     - Step 2: Add components to entities if needed
                        - In this case we don't need a component for the cube
                        - but below is the code to attach a component set to the entity for demonstration
                 */
                cube.components.set([HoverEffectComponent(), InputTargetComponent()])
                
    
                /*
                     - Step 3: Add every entity to an anchor entity
                        it's required for every entity to be a child of an anchor entity,
                        because an anchor entity is able to track a horizontal/vertical plane
                 */
                // Create an anchor that tracks a horizontal plane.
                let anchor = AnchorEntity(
                    plane: .horizontal,
                    classification: .any,
                    minimumBounds: [0.2, 0.2]
                )
                
                anchor.addChild(cube)
                
                /*
                    - Step 4: Add all anchors to the content which is an inout parameter
                        - you can also configure the content's properties here
                 */
                content.add(anchor)
                
                // Use spatial tracking for the camera.
                content.camera = .spatialTracking
                
            } update: { content in
                // --- Update Closure: called to update the scene ---
                
                // Assume the cube is the first child of the first anchor.
                if let anchor = content.entities.first,
                   let cube = anchor.children.first as? ModelEntity {
                    
                    // Update the cube's scale.
                    cube.scale = .init(repeating: self.scaleFactor)
                    
                    // Convert the drag offset (screen points) into world space (meters)
                    // using a simple factor.
                    let factor: Float = 0.001
                    let dragTranslation = SIMD3<Float>(
                        Float(self.dragOffset.width) * factor,
                        0,
                        Float(self.dragOffset.height) * factor
                    )
                    
                    // Update the cube’s position.
                    cube.position = self.cubeBasePosition + dragTranslation
                    
                    // Apply a highlight effect by updating the material.
                    // When isHighlighted is true, the cube appears yellow; otherwise gray.
                    cube.model?.materials = [
                        SimpleMaterial(
                            color: self.isHighlighted ? .yellow : .gray,
                            roughness: 0.15,
                            isMetallic: true
                        )
                    ]
                }
            }
            .edgesIgnoringSafeArea(.all)
            // Attach a drag gesture for moving the cube.
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.dragOffset = value.translation
                    }
                    .onEnded { value in
                        
                        let factor: Float = 0.001
                        let finalTranslation = SIMD3<Float>(
                            Float(value.translation.width) * factor,
                            0,
                            Float(value.translation.height) * factor
                        )
                        self.cubeBasePosition += finalTranslation
                        self.dragOffset = .zero
                    }
            )
            // Attach a pinch (magnification) gesture to adjust vertical position.
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        // Use the deviation from 1.0 to determine vertical movement.
                        // Adjust the conversion factor to suit your app.
                        let verticalFactor: Float = 0.1
                        self.pinchVerticalOffset = (Float(value) - 1.0) * verticalFactor
                    }
                    .onEnded { value in
                        let verticalFactor: Float = 0.1
                        let finalVerticalOffset = (Float(value) - 1.0) * verticalFactor
                        // Commit the vertical movement to the cube's base position.
                        self.cubeBasePosition.y += finalVerticalOffset
                        self.pinchVerticalOffset = 0.0
                    }
            )
            // Attach a tap gesture to toggle the highlight.
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        // Toggle the highlight state when the RealityView is tapped.
                        self.isHighlighted.toggle()
                    }
            )
            
            // A button to enlarge the cube.
            VStack {
                Spacer()
                Button {
                    self.scaleFactor *= 2
                } label: {
                    Text("Enlarge the cube")
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ARSessionView()
}
