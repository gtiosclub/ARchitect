import UIKit
import ARKit
import SceneKit

class ARViewController: UIViewController {
    var furniture: Furniture?
    let sceneView = ARSCNView()
    var modelNode: SCNNode?
    var currentScale: Float = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSceneView()
        setupZoomButtons()
        loadModel()
    }

    func setupSceneView() {
        sceneView.frame = view.bounds
        view.addSubview(sceneView)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        sceneView.session.run(config)
    }

    func setupZoomButtons() {
        let zoomInButton = UIButton(type: .system)
        zoomInButton.setTitle("+", for: .normal)
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)

        let zoomOutButton = UIButton(type: .system)
        zoomOutButton.setTitle("-", for: .normal)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [zoomOutButton, zoomInButton])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func loadModel() {
        guard let furniture = furniture else { return }
        guard let scene = try? SCNScene(url: Bundle.main.url(forResource: furniture.usdzFilename, withExtension: "usdz")!, options: nil) else {
            print("Failed to load .usdz file")
            return
        }
        
        modelNode = scene.rootNode.clone()
        if let node = modelNode {
            node.position = SCNVector3(0, -0.5, -1)
            sceneView.scene.rootNode.addChildNode(node)
        }
    }

    @objc func zoomIn() {
        scaleModel(by: 1.1)
    }

    @objc func zoomOut() {
        scaleModel(by: 0.9)
    }

    func scaleModel(by factor: Float) {
        currentScale *= factor
        modelNode?.scale = SCNVector3(currentScale, currentScale, currentScale)
    }
}
