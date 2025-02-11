//
//  ContentView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI
import RealityKit
import ARKit

struct ARSessionView: View {

    @State private var isEnlarged = false
    @State private var scaleFactor: Float = 1.0
    @State private var cubePosition: CGPoint = .zero
    @State private var cubeScreenPosition: CGPoint? = nil
    @State private var arView = ARView(frame: .zero)
    
    var body: some View {
        ZStack {
            ARViewContainer(arView: $arView, scaleFactor: $scaleFactor, cubeScreenPosition: $cubeScreenPosition)
                .edgesIgnoringSafeArea(.all)
            
            if let screenPosition = cubeScreenPosition {
                VStack {
                    Text("Cube Info")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)

                    Text("Color: Gray")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)

                    Text("Size: \(String(format: "%.2f", 0.1 * scaleFactor))m")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                }
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                .position(screenPosition) // Position the info box dynamically
            }
            
            VStack {
                Spacer()
                Button {
                    self.scaleFactor *= 2
                } label: {
                    Text("Enlarge the cube")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var arView: ARView
    @Binding var scaleFactor: Float
    @Binding var cubeScreenPosition: CGPoint?

    func makeUIView(context: Context) -> ARView {
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = [.horizontal]
        arView.session.run(arConfiguration)
        
        // Create cube model
        let model = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .gray, isMetallic: true)])
        model.name = "Cube"
        model.position = [0, 0.05, 0]
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(model)
        arView.scene.anchors.append(anchor)
        
        context.coordinator.model = model
        context.coordinator.anchor = anchor
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = context.coordinator.model {
            model.scale = SIMD3<Float>(scaleFactor, scaleFactor, scaleFactor)
            context.coordinator.updateCubeScreenPosition(in: uiView)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator {
        var parent: ARViewContainer
        var model: ModelEntity?
        var anchor: AnchorEntity?
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        func updateCubeScreenPosition(in arView: ARView) {
            DispatchQueue.main.async {
                if let model = self.model {
                    let worldPosition = model.position(relativeTo: nil)
                    let screenPosition = arView.project(worldPosition)
                    self.parent.cubeScreenPosition = screenPosition
                }
            }
        }
    }
}

#Preview {
    ARSessionView()
}
