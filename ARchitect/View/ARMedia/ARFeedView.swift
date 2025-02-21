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
    @State private var cubeEntity: ModelEntity?
    @State private var isHover: Bool = false
    
    var body: some View {
        VStack {
            RealityView { content in
                // Create a cube model
                let model = ModelEntity (
                    mesh: MeshResource.generateBox(size: cubeSize, cornerRadius: 0.005),
                    materials: [SimpleMaterial(color: .gray, roughness: 0.01, isMetallic: true)]
                )
                model.position = SIMD3<Float>(0, 0.01, 0)
                cubeEntity = model

                // Create horizontal plane anchor for the content
                let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
                anchor.addChild(model)

                // Add the horizontal plane anchor to the scene
                content.add(anchor)

                content.camera = .spatialTracking
            }
            // When cube is tapped, the object will hover in the air
            .gesture(
                TapGesture().onEnded {
                    guard let cube = cubeEntity else {return}
                    if isHover {
                        cube.position.y -= 0.1
                    } else {
                        cube.position.y += 0.1
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
