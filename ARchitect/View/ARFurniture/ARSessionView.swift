//
//  ContentView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI
import RealityKit

struct ARSessionView : View {

    @State private var isEnlarged = false
    @State private var scaleFactor : Float = 1.0

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

            } update: { content in
                // make the cube twice as large when the button is clicked on
                content.entities[0].scale = .one * SIMD3<Float>(self.scaleFactor, self.scaleFactor, self.scaleFactor)
            } placeholder: {
                ProgressView()
            }
            Button {
                // TODO
                self.scaleFactor *= 2
            } label: {
                Text("Enlarge the cube")
            }

        }
        
        .edgesIgnoringSafeArea(.all)
    }

}

#Preview {
    ARSessionView()
}
