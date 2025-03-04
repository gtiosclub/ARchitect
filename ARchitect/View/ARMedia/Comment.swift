//
//  Comment.swift
//  ARchitect
//
//  Created by Dhairya Patel on 2/20/25.
//

import Foundation

struct Comment: Identifiable {
    let id = UUID()
    let username: String = "username"
    let userImage: String = "person.circle.fill"
    let text: String
    let timestamp: Date
    let publisher: String
    var likes: Int
    var isLiked: Bool = false
}
