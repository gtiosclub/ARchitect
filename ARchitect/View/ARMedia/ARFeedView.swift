//
//  ARFeedView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI
import RealityKit
struct ARFeedView: View {
    
    @State private var cubeSize: Float = 0.10 // Start small
    @State private var entities: [ModelEntity] = []
    @State private var isHover: Bool = false
    
    var body: some View {
        VStack {
            RealityView { content in
                // Create a cube model
                let cube = ModelEntity(
                    mesh: MeshResource.generateBox(size: cubeSize, cornerRadius: 0.005),
                    materials: [SimpleMaterial(color: .gray, roughness: 0.01, isMetallic: true)]
                )
                cube.position = SIMD3<Float>(0, 0.01, 0)
                let sphere = ModelEntity(
                    mesh: MeshResource.generateSphere(radius: cubeSize / 2),
                    materials: [SimpleMaterial(color: .blue, roughness: 0.1, isMetallic: false)]
                )
                sphere.position = SIMD3<Float>(0.2, 0.01, 0) // Offset it from the cube
                // Store entities
                entities = [cube, sphere]
                // Create horizontal plane anchor
                let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
                
                // Add models to anchor
                for entity in entities {
                    anchor.addChild(entity)
                }
                // Add the horizontal plane anchor to the scene
                content.add(anchor)
                content.camera = .spatialTracking
            }
            // When cube is tapped, the object will hover in the air
            .gesture(
                TapGesture().onEnded {
                    for entity in entities {
                        entity.position.y += isHover ? -0.1 : 0.1
                    }
                    isHover.toggle()
                }
            )
        }
    }
}
#Preview {
    ARFeedView()
}
