import UIKit
import ARKit
import RealityKit

class ARViewController: UIViewController {
    var arView: ARView!
    var selectedFurniture: ModelEntity?
    var projectName: String = ""
    var projectDescription: String = ""
    var usedFurnitureModels: [String] = [] // Track furniture models used in the AR session

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        setupUI()

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        arView.addGestureRecognizer(panGestureRecognizer)

        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        arView.addGestureRecognizer(pinchGestureRecognizer)
    }

    func setupARView() {
        arView = ARView(frame: self.view.bounds)
        self.view.addSubview(arView)

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
    }

    func setupUI() {
        // Add a back arrow to navigate back to the entry view
        let backArrowButton = UIButton(frame: CGRect(x: 10, y: 30, width: 50, height: 50))
        backArrowButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backArrowButton.tintColor = .systemGray
        backArrowButton.addTarget(self, action: #selector(goBackToEntryView), for: .touchUpInside)
        self.view.addSubview(backArrowButton)

        let furnitureGalleryButton = UIButton(frame: CGRect(x: 20, y: 80, width: 150, height: 50))
        furnitureGalleryButton.setTitle("Furniture Gallery", for: .normal)
        furnitureGalleryButton.backgroundColor = .systemBlue
        furnitureGalleryButton.layer.cornerRadius = 8
        furnitureGalleryButton.addTarget(self, action: #selector(openFurnitureGallery), for: .touchUpInside)
        self.view.addSubview(furnitureGalleryButton)

        let saveButton = UIButton(frame: CGRect(x: 200, y: 80, width: 150, height: 50))
        saveButton.setTitle("Save the project", for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(takeScreenshot), for: .touchUpInside)
        self.view.addSubview(saveButton)
    }

    @objc func goBackToEntryView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func openFurnitureGallery() {
        let furnitureGalleryVC = FurnitureGalleryViewController()
        furnitureGalleryVC.delegate = self
        furnitureGalleryVC.modalPresentationStyle = .pageSheet
        if let sheet = furnitureGalleryVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(furnitureGalleryVC, animated: true, completion: nil)
    }

    @objc func takeScreenshot() {
        arView.snapshot(saveToHDR: false) { image in
            guard let screenshot = image else {
                print("Error: Failed to capture screenshot.")
                return
            }

            let screenshotVC = ScreenshotViewController()
            screenshotVC.screenshotImage = screenshot
            screenshotVC.usedFurnitureModels = self.usedFurnitureModels // Pass the furniture models used
            screenshotVC.modalPresentationStyle = .fullScreen
            self.present(screenshotVC, animated: true, completion: nil)
        }
    }

    func placeFurnitureInScene(modelEntity: ModelEntity) {
        guard let currentFrame = arView.session.currentFrame else {
            print("Error: Unable to get the current AR frame.")
            return
        }

        // Perform a raycast to check for a horizontal plane
        let raycastResults = arView.raycast(from: CGPoint(x: arView.bounds.midX, y: arView.bounds.midY), allowing: .estimatedPlane, alignment: .horizontal)

        if let raycastResult = raycastResults.first {
            // Place the furniture at the raycast result's position
            let worldPosition = SIMD3<Float>(
                raycastResult.worldTransform.columns.3.x,
                raycastResult.worldTransform.columns.3.y,
                raycastResult.worldTransform.columns.3.z
            )
            modelEntity.position = worldPosition

            let anchor = AnchorEntity(world: worldPosition)
            anchor.addChild(modelEntity)
            arView.scene.anchors.append(anchor)
            selectedFurniture = modelEntity // Set the selected furniture for manipulation
            print("Furniture placed in the scene at position: \(worldPosition).")
        } else {
            // Show an alert if no valid plane is detected
            showAlertForInsufficientSpace()
        }
    }

    func showAlertForInsufficientSpace() {
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: true) { [weak self] in
                self?.presentInsufficientSpaceAlert()
            }
        } else {
            presentInsufficientSpaceAlert()
        }
    }

    private func presentInsufficientSpaceAlert() {
        let alert = UIAlertController(
            title: "Insufficient Space",
            message: "It seems there isn't enough space in front of you to place the furniture. Please move to a more open area and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let arView = arView, let entity = selectedFurniture else { return }

        let touchLocation = gesture.location(in: arView)
        let hitTestResults = arView.raycast(from: touchLocation, allowing: .estimatedPlane, alignment: .horizontal)

        if let firstResult = hitTestResults.first {
            let worldPosition = SIMD3<Float>(firstResult.worldTransform.columns.3.x,
                                             firstResult.worldTransform.columns.3.y,
                                             firstResult.worldTransform.columns.3.z)

            if gesture.state == .began {
                print("Pan gesture began. Initial position: \(worldPosition)")
            } else if gesture.state == .changed {
                entity.position = worldPosition
                print("Pan gesture changed. Updated position: \(worldPosition)")
            } else if gesture.state == .ended {
                print("Pan gesture ended. Final position: \(worldPosition)")
            }
        } else {
            print("Pan gesture failed. No valid plane detected.")
        }
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let entity = selectedFurniture else { return }

        if gesture.state == .changed {
            let scale = Float(gesture.scale)
            entity.scale *= SIMD3<Float>(scale, scale, scale)
            gesture.scale = 1.0
        } else if gesture.state == .ended {
            print("Pinch gesture ended. Final scale: \(entity.scale)")
        }
    }
}

extension ARViewController: FurnitureGalleryDelegate {
    func furnitureSelected(named modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz") else {
            print("Error: Model \(modelName) not found in the local directory.")
            return
        }

        do {
            let modelEntity = try ModelEntity.loadModel(contentsOf: modelURL)
            modelEntity.generateCollisionShapes(recursive: true)
            placeFurnitureInScene(modelEntity: modelEntity)

            // Record the furniture model used
            if !usedFurnitureModels.contains(modelName) {
                usedFurnitureModels.append(modelName)
            }
        } catch {
            print("Error: Failed to load model \(modelName) with error: \(error).")
        }
    }
}
