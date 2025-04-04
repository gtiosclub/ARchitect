import UIKit
import ARKit
import RealityKit

class FurnitureWrapper {
    let entity: ModelEntity
    var isLocked: Bool = false
    var gestureRecognizers: [UIGestureRecognizer] = []

    init(entity: ModelEntity) {
        self.entity = entity
    }
}

class ARViewController: UIViewController {
    var arView: ARView!
    var selectedFurniture: ModelEntity?
    var projectName: String = ""
    var projectDescription: String = ""
    var usedFurnitureModels: [String] = [] // Track furniture models used in the AR session
    var furnitureWrappers: [FurnitureWrapper] = [] // Track furniture models with gestures

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        setupUI()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 2
        arView.addGestureRecognizer(tapGesture)

    }

    func setupARView() {
        arView = ARView(frame: self.view.bounds)
        self.view.addSubview(arView)

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal] // Enable horizontal plane detection
        configuration.environmentTexturing = .automatic // Enable environment texturing for better rendering
        arView.session.run(configuration)

        // Ensure RealityKit rendering is properly configured
        arView.automaticallyConfigureSession = false // Prevent ARView from overriding the session configuration
        arView.renderOptions.insert(.disableMotionBlur) // Optional: Disable motion blur for better performance
    }

    func setupUI() {
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

    func createInfoBox(for modelEntity: ModelEntity, modelName: String) -> Entity {
        let textMesh = MeshResource.generateText(
            "Furniture Info\nName: \(modelName)\nSize: \(modelEntity.scale)",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.03),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        )
        let textMaterial = SimpleMaterial(color: .black, isMetallic: false)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)

        let textBounds = textMesh.bounds
        let textWidth = textBounds.max.x - textBounds.min.x
        let textHeight = textBounds.max.y - textBounds.min.y

        let boxMesh = MeshResource.generateBox(size: [textWidth * 0.6, textHeight * 0.6, 0.01])
        let boxMaterial = SimpleMaterial(color: .white, isMetallic: false)
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        boxEntity.position = [0, 0, -0.005]

        let textOffsetX = -textBounds.center.x * 0.5
        let textOffsetY = -textBounds.center.y * 0.5
        textEntity.position = [textOffsetX, textOffsetY, 0.005]

        let infoBoxEntity = Entity()
        infoBoxEntity.addChild(boxEntity)
        infoBoxEntity.addChild(textEntity)

        return infoBoxEntity
    }

    func placeFurnitureInScene(modelEntity: ModelEntity, modelName: String) {
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

            // Add gestures for translation, rotation, and scaling
            let gestures = arView.installGestures([.translation, .rotation, .scale], for: modelEntity)
            let furnitureWrapper = FurnitureWrapper(entity: modelEntity)
            furnitureWrapper.gestureRecognizers = gestures
            furnitureWrappers.append(furnitureWrapper)

            // Add an info box to the furniture
            let infoBox = createInfoBox(for: modelEntity, modelName: modelName)
            infoBox.position = SIMD3<Float>(0, 0.2, 0) // Position the info box above the model
            modelEntity.addChild(infoBox)

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


    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arView)
        if let tappedEntity = arView.entity(at: tapLocation) {
            if let furnitureWrapper = furnitureWrappers.first(where: { $0.entity === tappedEntity }) {
                if !furnitureWrapper.isLocked {
                    furnitureWrapper.isLocked = true
                    for gesture in furnitureWrapper.gestureRecognizers {
                        arView.removeGestureRecognizer(gesture)
                    }
                    furnitureWrapper.gestureRecognizers.removeAll()
                    print("\(furnitureWrapper.entity.name) locked")
                } else {
                    furnitureWrapper.isLocked = false
                    let newGestures = arView.installGestures([.translation, .rotation, .scale], for: furnitureWrapper.entity)
                    furnitureWrapper.gestureRecognizers = newGestures
                    print("\(furnitureWrapper.entity.name) unlocked")
                }
            }
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
            placeFurnitureInScene(modelEntity: modelEntity, modelName: modelName) // Pass modelName to display in the info box

            // Record the furniture model used
            if !usedFurnitureModels.contains(modelName) {
                usedFurnitureModels.append(modelName)
            }
        } catch {
            print("Error: Failed to load model \(modelName) with error: \(error).")
        }
    }
}
