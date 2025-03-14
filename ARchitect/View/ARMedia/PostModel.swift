//
//  PostModel.swift
//  ARchitect
//
//  Created by Amiire kolawole on 2025-03-03.
//

import Foundation

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let userImage: String
    let title: String
    let imageName: String
    let tags: [String]
    let description: String
    let timeAgo: String
    var likes: Int
    var user_liked: Bool = false
    var commentsModel: CommentViewModel = CommentViewModel()
    let environment = VREnvironmentConfig(
        environmentModel: "apartment_room",
        environmentPosition: SIMD3<Float>(0, 0, 0),
        environmentScale: SIMD3<Float>(1, 1, 1),
        objects: [
            VREnvironmentConfig.VRObjectConfig(
                modelName: "modern chair",
                displayName: "Modern Chair",
                description: "A stylish modern chair with minimalist design.",
                position: SIMD3<Float>(0, 0, 0),
                scale: SIMD3<Float>(0.005, 0.005, 0.005),
                properties: [
                    "Price": "$499.99",
                    "Material": "Leather and metal",
                    "Dimensions": "28\" × 30\" × 32\""
                ]
            ),
            VREnvironmentConfig.VRObjectConfig(
                modelName: "GreyCouch",
                displayName: "Grey Couch",
                description: "Grey Couch.",
                position: SIMD3<Float>(0, 0, -2),
                scale: SIMD3<Float>(0.0005, 0.0005, 0.0005),
                properties: [
                    "Price": "$299.99",
                    "Material": "Polyester",
                    "Dimensions": "48\" × 24\" × 18\""
                ]
            )
            // Add more objects as needed
        ]
    )
}
