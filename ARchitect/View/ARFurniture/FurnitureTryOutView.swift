//
//  FurnitureTryOutView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 4/14/25.
//
import SwiftUI
import RealityKit

struct FurnitureTryOutView: View {
    @GestureState private var gestureAngle: Angle = .degrees(0)
    @State private var totalAngle: Angle = .degrees(0)

    var body: some View {
        RealityView { content in
            content.camera = .virtual

            let anchor = AnchorEntity(world: SIMD3<Float>(0, -1.0, -1.5))
            content.add(anchor)

            if let couch = try? await ModelEntity(named: "Arm chair") {
                couch.name = "armChair"
                couch.setScale(SIMD3<Float>(0.8, 0.8, 0.8), relativeTo: couch)
                couch.components.set(InputTargetComponent())
                couch.components.set(CollisionComponent(shapes: [.generateBox(width: 1, height: 1, depth: 1)]))
                anchor.addChild(couch)
            }
        } update: { content in
            if let couch = content.entities.first(where: { $0.name == "armChair" }) {
                let totalRotation = Float((totalAngle + gestureAngle).radians)
                couch.transform.rotation = simd_quatf(angle: totalRotation, axis: [0, 1, 0])
            }
        }
        .gesture(rotationGesture)
    }

    private var rotationGesture: some Gesture {
        RotationGesture()
            .updating($gestureAngle) { value, state, _ in
                state = value
            }
            .onEnded { value in
                totalAngle += value
            }
    }
}





#Preview {
    FurnitureTryOutView()
}
