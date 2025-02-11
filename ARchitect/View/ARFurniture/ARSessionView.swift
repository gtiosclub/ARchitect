import SwiftUI
import RealityKit
import ARKit

struct ARSessionView: View, UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
         let arView = ARView(frame: .zero)
         let config = ARWorldTrackingConfiguration()
         config.planeDetection = [.horizontal]
         arView.session.run(config)
         
         let box = ModelEntity(mesh: .generateBox(size: 0.3), materials: [SimpleMaterial(color: .blue, isMetallic: false)])
         box.generateCollisionShapes(recursive: true)
         
         let anchor = AnchorEntity(plane: .horizontal)
         anchor.addChild(box)
         arView.scene.anchors.append(anchor)
         
         box.components.set(InputTargetComponent())
         
         let panGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
         arView.addGestureRecognizer(panGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        arView.addGestureRecognizer(pinchGestureRecognizer)
         
        
        context.coordinator.arView = arView
        context.coordinator.selectedEntity = box
         
        return arView
     }
     
     func updateUIView(_ uiView: ARView, context: Context) {}
     
     func makeCoordinator() -> Coordinator {
         Coordinator()
     }
     
     class Coordinator: NSObject {
         weak var arView: ARView?
         var selectedEntity: ModelEntity?
         var lastWorldPosition: SIMD3<Float>?
         
         @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
             guard let arView = arView, let entity = selectedEntity else { return }
             
             let touchLocation = gesture.location(in: arView)
             let hitTestResults = arView.raycast(from: touchLocation, allowing: .estimatedPlane, alignment: .horizontal)
             
             if let firstResult = hitTestResults.first {
                 let worldPosition = SIMD3<Float>(firstResult.worldTransform.columns.3.x, firstResult.worldTransform.columns.3.y, firstResult.worldTransform.columns.3.z)
                 
                 if gesture.state == .began {
                     lastWorldPosition = worldPosition
                 } else if gesture.state == .changed, let lastPosition = lastWorldPosition {
                     let translation = worldPosition - lastPosition
                     entity.position += translation
                     lastWorldPosition = worldPosition
                 }
             }
         }
         
         @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
             guard let entity = selectedEntity else { return }
             
             let scale = Float(gesture.scale)
             entity.scale = SIMD3<Float>(repeating: scale)
                         
             if gesture.state == .ended {
                 gesture.scale = 1.0
             }
         }
     }
 }

