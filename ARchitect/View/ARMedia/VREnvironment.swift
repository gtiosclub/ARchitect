//
//  VREnvironment.swift
//  ARchitect
//
//  Created by Amiire kolawole on 2025-03-13.
//

import SwiftUI
import RealityKit
import ARKit

struct VREnvironmentConfig2 {
    let environmentModel: String?
    let environmentPosition: SIMD3<Float>
    let environmentScale: SIMD3<Float>
    
    let objects: [VRObjectConfig]
    
    struct VRObjectConfig: Identifiable {
        let id = UUID()
        let modelName: String
        let displayName: String
        let description: String
        let position: SIMD3<Float>
        let scale: SIMD3<Float>
        let properties: [String: String]
    }
}

struct VREnvironmentView: View {
    let config: VREnvironmentConfig2
    
    @State private var isHover: Bool = false
    @State private var entities: [ModelEntity] = []
    @State private var selectedEntity: ModelEntity? = nil
    @State private var showInfoPanel: Bool = false
    @State private var selectedObjectInfo: VREnvironmentConfig2.VRObjectConfig? = nil
    
    var body: some View {
        ZStack {
            RealityView { content in
                if let environmentModelName = config.environmentModel {
                    var environmentEntity: ModelEntity?
                    
                    do {
                        environmentEntity = try await ModelEntity(named: environmentModelName)
                    } catch {
                        print("Failed to import environment model: \(error)")
                    }
                    
                    let environmentAnchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
                    
                    if let entity = environmentEntity {
                        entity.transform.scale = config.environmentScale
                        entity.position = config.environmentPosition
                        entity.generateCollisionShapes(recursive: true)
                        environmentAnchor.addChild(entity)
                        entities.append(entity)
                    }
                    
                    content.add(environmentAnchor)
                }
                
                for objectConfig in config.objects {
                    var objectEntity: ModelEntity?
                    
                    do {
                        objectEntity = try await ModelEntity(named: objectConfig.modelName)
                    } catch {
                        print("Failed to import model \(objectConfig.modelName): \(error)")
                    }
                    
                    let newAnchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
                    
                    if let modelEntity = objectEntity {
                        modelEntity.name = objectConfig.id.uuidString
                        modelEntity.transform.scale = objectConfig.scale
                        modelEntity.position = objectConfig.position
                        modelEntity.generateCollisionShapes(recursive: true)
                        
                        newAnchor.addChild(modelEntity)
                        entities.append(modelEntity)
                    }
                    
                    content.add(newAnchor)
                }
                
                // Setup lighting
                let directionalLight = DirectionalLight()
                directionalLight.light.intensity = 1000
                directionalLight.look(at: [0, 0, 0], from: [1, 1, 1], relativeTo: nil)
                
                let lightAnchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
                lightAnchor.addChild(directionalLight)
                content.add(lightAnchor)
                
                content.camera = .spatialTracking
            }
            .gesture(
                SpatialTapGesture()
                    .onEnded { event in
                        print(type(of: event))
                        handleTap(at: event.location)
                    }
            )
            
            if showInfoPanel, let objectInfo = selectedObjectInfo {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(objectInfo.displayName)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                showInfoPanel = false
                                selectedEntity = nil
                                selectedObjectInfo = nil
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text(objectInfo.description)
                        .font(.body)
                        .padding(.vertical, 8)
                    
                    if !objectInfo.properties.isEmpty {
                        Divider()
                        
                        ForEach(Array(objectInfo.properties.keys.sorted()), id: \.self) { key in
                            if let value = objectInfo.properties[key] {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(key)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    Text(value)
                                        .font(.body)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .padding()
                .frame(width: 280, height: 300)
                .background(Color.white)
                .foregroundColor(Color.black)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                .position(x: UIScreen.main.bounds.width - 160, y: 160)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    // Handle tap interaction
    private func handleTap(at location: CGPoint) {
        isHover.toggle()
        
        if showInfoPanel {
            if let entity = selectedEntity {
                entity.position.y -= 0.25
            }
            
            withAnimation {
                showInfoPanel = false
                selectedEntity = nil
                selectedObjectInfo = nil
            }
            
            return
        }
        
        // For demonstration, select the first object when tapped
        // In a real app, you would use ray casting to determine which object was tapped
        if let firstObject = config.objects.first {
            withAnimation {
                selectedObjectInfo = firstObject
                selectedEntity = entities.first(where: { $0.name == firstObject.id.uuidString })
                if let entity = selectedEntity {
                    entity.position.y += 0.25
                }
                showInfoPanel = true
            }
        }
    }
}

// Preview provider
struct VREnvironmentView_Previews: PreviewProvider {
    static var previews: some View {
        VREnvironmentView(config: VREnvironmentConfig2(
            environmentModel: "living_room",
            environmentPosition: SIMD3<Float>(0, 0, 0),
            environmentScale: SIMD3<Float>(0.1, 0.1, 0.1),
            objects: [
                VREnvironmentConfig2.VRObjectConfig(
                    modelName: "modern chair",
                    displayName: "Modern Chair",
                    description: "A stylish modern chair with minimalist design.",
                    position: SIMD3<Float>(0.3, 0, -0.5),
                    scale: SIMD3<Float>(0.005, 0.005, 0.005),
                    properties: [
                        "Price": "$499.99",
                        "Material": "Leather and metal",
                        "Dimensions": "28\" × 30\" × 32\""
                    ]
                ),
                VREnvironmentConfig2.VRObjectConfig(
                    modelName: "GreyCouch",
                    displayName: "Grey Couch",
                    description: "Grey Couch.",
                    position: SIMD3<Float>(0.3, 0, -1),
                    scale: SIMD3<Float>(0.005, 0.005, 0.005),
                    properties: [
                        "Price": "$299.99",
                        "Material": "Polyester",
                        "Dimensions": "48\" × 24\" × 18\""
                    ]
                )
            ]
        ))
    }
}

// Example usage:
/*
struct ContentView: View {
    var body: some View {
        VREnvironmentView(config: VREnvironmentConfig2(
            environmentModel: "modern_apartment",
            environmentPosition: SIMD3<Float>(0, 0, 0),
            environmentScale: SIMD3<Float>(0.1, 0.1, 0.1),
            objects: [
                VREnvironmentConfig2.VRObjectConfig(
                    modelName: "modern chair",
                    displayName: "Designer Chair",
                    description: "Award-winning modern designer chair.",
                    position: SIMD3<Float>(0.5, 0, -1),
                    scale: SIMD3<Float>(0.005, 0.005, 0.005),
                    properties: [
                        "Price": "$899.99",
                        "Designer": "Jean Prouvé",
                        "Year": "2023"
                    ]
                )
                // Add more objects as needed
            ]
        ))
    }
}
*/
