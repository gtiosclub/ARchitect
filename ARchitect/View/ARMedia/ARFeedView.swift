//
//  ARFeedView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI
import RealityKit

struct ARFeedView: View {
    @State private var entities: [ModelEntity] = []
    @State private var isHover: Bool = false
    @State private var selectedEntity: ModelEntity? = nil
    @State private var showPopup: Bool = false

    // Store information about the selected object
    @State private var selectedName: String = ""
    @State private var selectedDescription: String = ""
    @State private var selectedCost: String = ""
    @State private var selectedStores: String = ""

    @StateObject var sheetManager = SheetManager()

    var body: some View {
        ZStack {
            VStack {
                RealityView { content in
                    var modelEntity: ModelEntity?
                    
                    // Code for adding in model
                    do {
                        modelEntity = try await ModelEntity(named: "modern chair")
                    } catch {
                        print("Failed to import model: \(error)")
                    }

                    let newAnchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))

                    if let modelEntity = modelEntity {
                        modelEntity.transform.scale = SIMD3<Float>(0.005, 0.005, 0.005) // 🔹 Smaller Size
                        modelEntity.position = SIMD3<Float>(0, 0.01, 0)
                        modelEntity.generateCollisionShapes(recursive: true)
                        newAnchor.addChild(modelEntity)
                        entities.append(modelEntity)
                    }

                    content.add(newAnchor)
                    content.camera = .spatialTracking
                }
                // Hovering code
                .gesture(
                    TapGesture().onEnded {
                        if selectedEntity != nil {
                            // Changes if object is floating up or down
                            isHover.toggle()
                            selectedEntity = nil
                            showPopup = false
                        } else {
                            if let firstEntity = entities.first {
                                selectedEntity = firstEntity
                                isHover.toggle()
                                showPopup = true

                                DispatchQueue.main.async {
                                    selectedName = "Modern Chair"
                                    selectedDescription = "A chair with a simple, clean design."
                                    selectedCost = "499.99"
                                    selectedStores = "Available at your nearest IKEA, Target, and Walmart."
                                }
                            }
                        }

                        for entity in entities {
                            entity.position.y += isHover ? 0.25 : -0.25
                        }
                    }
                )
            }

            // Display the pop-up when an entity is selected
            if showPopup, let _ = selectedEntity {
                InformationPopUpView(
                    didClose: {
                        showPopup = false
                        selectedEntity = nil
                        isHover.toggle()
                        for entity in entities {
                            entity.position.y -= 0.25
                        }
                    },
                    name: selectedName,
                    description: selectedDescription,
                    cost: selectedCost,
                    stores: selectedStores
                )
                .environmentObject(sheetManager)
                .frame(width: 280, height: 300)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                .position(x: UIScreen.main.bounds.width - 160, y: 160)
            }
        }
    }
}

#Preview {
    ARFeedView()
        .environmentObject(SheetManager())
}
