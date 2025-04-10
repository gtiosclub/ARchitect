//
//  Furniture3DView.swift
//  ARchitect
//
//  Created by Lingchen Xiao on 4/3/25.
//

import SwiftUI
import RealityKit

struct Furniture3DView: View {
    let item: FurnitureItem  // Stores the furniture item to load its model
    @State private var anchor: AnchorEntity?  // Stores the RealityKit anchor

    var body: some View {
        
        RealityView { content in
            if let anchor = anchor {
                content.add(anchor)  // Only add anchor if it's loaded
                content.camera = .spatialTracking
            }
        }
        .task {
            await loadModel()
        }
    }

    private func loadModel() async {
        do {
            // Load the 3D model using the item's model name asynchronously
            let modelEntity = try await ModelEntity(named: item.imageName)

            // Create an anchor entity for the model
            let anchorEntity = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
            anchorEntity.addChild(modelEntity)  // Attach model to anchor

            // Ensure updates are done on the main thread
            await MainActor.run {
                self.anchor = anchorEntity
            }
        } catch {
            print("Failed to load model: \(error)")
        }
    }
}


