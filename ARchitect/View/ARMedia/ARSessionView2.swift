import SwiftUI
import RealityKit
import ARKit

struct VREnvironmentConfig {
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

class EntityWrapper: Identifiable {
    let id = UUID()
    let entity: ModelEntity
    let config: VREnvironmentConfig.VRObjectConfig
    
    init(entity: ModelEntity, config: VREnvironmentConfig.VRObjectConfig) {
        self.entity = entity
        self.config = config
    }
}

struct ARSessionView2: View {
    @State private var arView = ARView(frame: .zero)
    let config: VREnvironmentConfig
    @State private var showInfoPanel: Bool = false
    @State private var selectedEntity: ModelEntity? = nil
    @State private var selectedObjectInfo: VREnvironmentConfig.VRObjectConfig? = nil
    
    var body: some View {
        ZStack {
            ARViewContainer2(
                config: config,
                arView: $arView,
                showInfoPanel: $showInfoPanel,
                selectedEntity: $selectedEntity,
                selectedObjectInfo: $selectedObjectInfo
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
                                // Animate entity back down before closing panel
                                if let entity = selectedEntity {
                                    entity.position.y -= 0.25
                                }
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
}

struct ARViewContainer2: UIViewRepresentable {
    let config: VREnvironmentConfig
    @Binding var arView: ARView
    
    @Binding var showInfoPanel: Bool
    @Binding var selectedEntity: ModelEntity?
    @Binding var selectedObjectInfo: VREnvironmentConfig.VRObjectConfig?
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update logic if needed
    }
    
    func makeUIView(context: Context) -> ARView {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        arView.scene.anchors.append(anchor)
        
        // Set up coordinator with proper references
        context.coordinator.arView = arView
        context.coordinator.anchor = anchor
        
        // Load models - objects first, then environment
        loadObjects(context: context)
        loadEnvironment(context: context)
        
        // Set up tap gesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator,
                                               action: #selector(Coordinator.handleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 2
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    private func loadEnvironment(context: Context) {
        // Load environment model last
        if let environmentModel = config.environmentModel {
            Task {
                do {
                    let environmentEntity = try await ModelEntity.loadModel(named: environmentModel)
                    print("environment: ", environmentEntity.id)
                    environmentEntity.name = "environment"
                    environmentEntity.transform.scale = config.environmentScale
                    environmentEntity.position = config.environmentPosition
                    environmentEntity.generateCollisionShapes(recursive: true)
                    
                    context.coordinator.environmentEntity = environmentEntity
                    context.coordinator.anchor?.addChild(environmentEntity)
                } catch {
                    print("Failed to import environment model: \(error)")
                }
            }
        }
    }
    
    private func loadObjects(context: Context) {
        // Load object models first
        for objectConfig in config.objects {
            Task {
                do {
                    let objectEntity = try await ModelEntity.loadModel(named: objectConfig.modelName)
                    objectEntity.name = objectConfig.displayName
                    objectEntity.transform.scale = objectConfig.scale
                    objectEntity.position = objectConfig.position
                    
                    // Add collision shapes for interactive objects
                    objectEntity.generateCollisionShapes(recursive: true)
                    
                    // Create interaction components for better ray casting
                    objectEntity.collision?.filter = CollisionFilter(group: .all, mask: .all)

                    context.coordinator.anchor?.addChild(objectEntity)
                    
                    // Store object entity for interaction
                    let entityWrapper = EntityWrapper(entity: objectEntity, config: objectConfig)
                    context.coordinator.entities.append(entityWrapper)
                } catch {
                    print("Failed to import model \(objectConfig.modelName): \(error)")
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer2
        weak var arView: ARView?
        var anchor: AnchorEntity?
        var entities: [EntityWrapper] = []
        var environmentEntity: ModelEntity?
        
        init(_ parent: ARViewContainer2) {
            self.parent = parent
        }
        
        @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
            guard let arView = arView else { return }
            
            // If a panel is already open, close it
            if parent.showInfoPanel {
                // Animate entity back down before closing panel
                if let entity = parent.selectedEntity {
                    entity.position.y -= 0.25
                }
                
                // Update parent state
                DispatchQueue.main.async {
                    self.parent.showInfoPanel = false
                    self.parent.selectedEntity = nil
                    self.parent.selectedObjectInfo = nil
                }
                return
            }
            print("Continue")
            // Handle opening a panel for a tapped entity
            let tapLocation = sender.location(in: arView)
            
            // First try a precise ray-cast to find interactive objects
            let results = arView.raycast(from: tapLocation,
                                         allowing: .estimatedPlane,
                                         alignment: .any)
            
            if let firstResult = results.first {
                print("entered")
                // Convert the raycast hit to a position in world space
                let worldPosition = firstResult.worldTransform.columns.3
                let hitPosition = SIMD3<Float>(worldPosition.x, worldPosition.y, worldPosition.z)
                print("hitPosition", hitPosition)
                
                // Find the closest object to the hit point
                var closestEntity: EntityWrapper? = nil
                var closestDistance: Float = 1000 // Maximum distance threshold
                
                for entityWrapper in entities {
                    let distance = simd_distance(entityWrapper.entity.position, hitPosition)
                    print(entityWrapper.entity.name, distance)
                    if distance < closestDistance {
                        closestEntity = entityWrapper
                        closestDistance = distance
                    }
                }
                
                if let entityWrapper = closestEntity {
                    print(entityWrapper.entity.name)
                    // Animate the entity up
                    entityWrapper.entity.position.y += 0.25
                    
                    // Update UI state
                    DispatchQueue.main.async {
                        self.parent.selectedObjectInfo = entityWrapper.config
                        self.parent.selectedEntity = entityWrapper.entity
                        self.parent.showInfoPanel = true
                    }
                    return
                }
            }
            
            // Fallback to entity-based hit testing if ray-cast doesn't work
            if let tappedEntity = arView.entity(at: tapLocation) {
                print("Tapped entity: \(tappedEntity.name)")
                
                // Skip if it's the environment entity
                if tappedEntity === environmentEntity ||
                   environmentEntity?.children.contains(where: { $0 === tappedEntity }) == true {
                    print("Skipping environment entity")
                    return
                }
                
                // Find the matching entity wrapper
                if let entityWrapper = entities.first(where: {
                    $0.entity === tappedEntity ||
                    $0.entity.children.contains(where: { $0 === tappedEntity })
                }) {
                    print("Selected object: \(entityWrapper.config.displayName)")
                    
                    // Animate the entity up
                    entityWrapper.entity.position.y += 0.25
                    
                    // Update UI state
                    DispatchQueue.main.async {
                        self.parent.selectedObjectInfo = entityWrapper.config
                        self.parent.selectedEntity = entityWrapper.entity
                        self.parent.showInfoPanel = true
                    }
                }
            }
        }
    }
}
