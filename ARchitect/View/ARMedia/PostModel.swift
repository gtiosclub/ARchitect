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
    var comments: [Comment] = [Comment(username: "Sam", timeAgo: "3 days ago", likes: 10, comment: "This is a great post and I am so happy with it")]
    
    struct Comment: Identifiable {
        let id = UUID()
        let username: String
        let userImage: String = "person.circle.fill"
        let timeAgo: String
        var likes: Int
        var user_liked: Bool = false
        var comment: String
    }
}

