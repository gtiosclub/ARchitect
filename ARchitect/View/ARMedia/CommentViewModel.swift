//
//  CommentViewModel.swift
//  ARchitect
//
//  Created by Dhairya Patel on 2/20/25.
//

import SwiftUI

class CommentViewModel: ObservableObject {
    var fbVM = FirebaseViewModel.vm
    @Published var comments: [Comment] = [
        Comment(text: "This is a test comment!", timestamp: Date(), publisher: "TestUser", likes: 0)
    ]
    
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
    func populateComments(postId: String) async {
        let allComments = await fbVM.getCommentsFromPost(postId: postId);
        DispatchQueue.main.async {
            self.comments = allComments["comments"];
        }
    }
    func addComment(text: String, publisher: String) {
        let newComment = Comment(text: text, timestamp: Date(), publisher: publisher, likes: 0)
        comments.append(newComment)
    }
    
    func addCommentToFirebase(comment: Comment, postId: String) async {
        fbVM.addCommentToFirebase(comment: comment, postId: postId);
    }
    
    func toggleLikeToFirebase(comment: Comment, postId: String) async {
        if let index = comments.firstIndex(where: { $0.id == comment.id }) {
            if comments[index].isLiked {
                // Remove like
                bVM.updateLikesForComment (postId: postId, commentId: comment.id, like: -1)
            } else {
                // Add like
                bVM.updateLikesForComment (postId: postId, commentId: comment.id, like: 1)
           
    }
    
    func toggleLike(for comment: Comment) {
        if let index = comments.firstIndex(where: { $0.id == comment.id }) {
            if comments[index].isLiked {
                // Remove like
                comments[index].likes = max(comments[index].likes - 1, 0)
                comments[index].isLiked = false
            } else {
                // Add like
                comments[index].likes += 1
                comments[index].isLiked = true
            }
        }
    }
    
    func length() -> Int {
        return comments.count
    }
    func addCommentToPost (comment: Comment) {
        
    }
}
//class CommentViewModel: ObservableObject {
//    @Published var comments: [Comment] = [
//        Comment(text: "This is a test comment!", timestamp: Date(), publisher: "TestUser")
//    ] // 🔥 Add a default comment
//}
