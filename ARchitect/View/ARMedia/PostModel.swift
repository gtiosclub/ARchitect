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
   
//    var environment: VREnvironmentConfig
//
//        init(
//            username: String,
//            userImage: String,
//            title: String,
//            imageName: String,
//            tags: [String],
//            description: String,
//            timeAgo: String,
//            likes: Int
//        ) {
//            self.username = username
//            self.userImage = userImage
//            self.title = title
//            self.imageName = imageName
//            self.tags = tags
//            self.description = description
//            self.timeAgo = timeAgo
//            self.likes = likes
//            
//            self.environment = VREnvironmentConfig(postID: self.id)
//        }
    
    mutating func toggleLike() {
        if user_liked {
            likes = max(likes - 1, 0)
        } else {
            likes += 1
        }
        user_liked.toggle()
    }
    
    mutating func addComment(text: String, publisher: String) {
        commentsModel.addComment(text: text, publisher: publisher)
    }
    
//    func numberOfComments() -> Int {
//        commentsModel.length()
//    }
    
    
}
