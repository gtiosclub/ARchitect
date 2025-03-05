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
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        arView.addGestureRecognizer(doubleTapGestureRecognizer)
        
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
        var lastPanLocation: CGPoint?
        var isMoving = false
        var originalMaterial: SimpleMaterial?
        var scaleLabel: UILabel?
        var scaleTimer: Timer?
        var lockButton: UIButton?
        var isLocked = false
        var lockButtonClicked = false
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            if isMoving {
                handlePanMove(gesture)
            } else {
                handlePanRotate(gesture)
            }
        }
        
        @objc func handlePanMove(_ gesture: UIPanGestureRecognizer) {
            guard let entity = selectedEntity, !isLocked else { return }
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
            if gesture.state == .ended {
                if isMoving {
                    removeSelectionColor()
                    isMoving = false
                    if !lockButtonClicked {
                        hideLockButton()
                    }
                }
            }
        }
        
        
        @objc func handlePanRotate(_ gesture: UIPanGestureRecognizer) {
            guard let entity = selectedEntity, !isLocked else { return }
            
            let translation = gesture.translation(in: gesture.view)
            
            if gesture.state == .began {
                lastPanLocation = translation
            } else if gesture.state == .changed, let lastLocation = lastPanLocation {
                let deltaX = Float(translation.x - lastLocation.x) * 0.005 // Sensitivity factor
                entity.transform.rotation *= simd_quatf(angle: deltaX, axis: [0, 1, 0])
                lastPanLocation = translation
            } else if gesture.state == .ended {
                lastPanLocation = nil
            }
        }
        
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let entity = selectedEntity, !isLocked else { return }
            
            let scale = Float(gesture.scale)
            entity.scale = SIMD3<Float>(repeating: scale)
            
            if gesture.state == .changed {
                showScaleLabel(scale: scale)
            } else if gesture.state == .ended {
                gesture.scale = 1.0
                removeSelectionColor()
                hideScaleLabel()
            }
        }
        
        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let entity = selectedEntity, !isLocked else { return }
            
            if !isMoving {
                addSelectionColor(to: entity)
                isMoving = true
                showLockButton()
            } else {
                removeSelectionColor()
                isMoving = false
                if !lockButtonClicked {
                    hideLockButton()
                }
            }
        }
        
        private func addSelectionColor(to entity: ModelEntity) {
            if let material = entity.model?.materials.first as? SimpleMaterial {
                originalMaterial = material
                var newMaterial = material
                newMaterial.color = .init(tint: .green.withAlphaComponent(0.5))
                entity.model?.materials = [newMaterial]
            }
        }
        
        private func removeSelectionColor() {
            if let entity = selectedEntity, let originalMaterial = originalMaterial {
                entity.model?.materials = [originalMaterial]
                self.originalMaterial = nil
            }
        }
        
        private func showScaleLabel(scale: Float) {
            if scaleLabel == nil {
                scaleLabel = UILabel(frame: CGRect(x: 20, y: 50, width: 100, height: 40))
                scaleLabel?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                scaleLabel?.textColor = .white
                scaleLabel?.textAlignment = .center
                arView?.addSubview(scaleLabel!)
            }
            scaleLabel?.text = "\(Int(scale * 100))%"
            scaleTimer?.invalidate()
            scaleTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
                self?.hideScaleLabel()
            }
        }
        
        private func hideScaleLabel() {
            scaleLabel?.removeFromSuperview()
            scaleLabel = nil
        }
        
        private func showLockButton() {
            if lockButton == nil {
                lockButton = UIButton(type: .system)
                lockButton?.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
                lockButton?.setImage(UIImage(systemName: "lock.open"), for: .normal)
                lockButton?.backgroundColor = UIColor.white.withAlphaComponent(0.8)
                lockButton?.layer.cornerRadius = 20
                lockButton?.layer.borderWidth = 1
                lockButton?.layer.borderColor = UIColor.gray.cgColor
                lockButton?.addTarget(self, action: #selector(handleLockButtonTap), for: .touchUpInside)
                arView?.addSubview(lockButton!)
            }
            lockButton?.isHidden = false
        }
        
        private func hideLockButton() {
            lockButton?.isHidden = true
        }
        
        @objc private func handleLockButtonTap() {
            isLocked.toggle()
            lockButtonClicked = isLocked
            if isLocked {
                lockButton?.setImage(UIImage(systemName: "lock"), for: .normal)
                removeSelectionColor()
                isMoving = false
            } else {
                lockButton?.setImage(UIImage(systemName: "lock.open"), for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hideLockButton()
                }
            }
        }
    }
}
