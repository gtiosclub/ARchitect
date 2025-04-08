//
//  FirebaseViewModel.swift
//  ARchitect
//
//  Created by Neel Bhattacharyya on 4/3/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class FirebaseViewModel: ObservableObject {
    let db = Firestore.firestore()
    func addCommentToPost(postId: String, comment: String) {
        let commentsRef = db.collection("posts").document(postId).collection("comments")
        let commentData: [String:Any] = [
            "comment" : comment,
            "likes" : 0
        ]
        try await commentsRef.addDocument(data: commentData) { error in
                if let error = error {
                    print("Error adding comment: \(error.localizedDescription)")
                } else {
                    print("Comment added successfully!")
                }
            }
    }
    func updateLikesForComment (postId: String, commentId: String, like: Int) {
        let commentsRef = db.collection("posts").document(postId).collection("comments").document(commentID)
        do {
                try await commentRef.updateData([
                    "likes": FieldValue.increment(Int64(like))
                ])
                print("Updated likes successfully!")
            } catch {
                print("Error updating likes: \(error.localizedDescription)")
            }
    }
    func getAllPosts() async -> [Post] {
        var posts: [Post] = []
        let postsSnapshot = try! await db.collection("posts").getDocuments()
        for snapshot in postsSnapshot.documents {
            let data = snapshot.data()
            let id = snapshot.documentID
            let title = data["title"] as! String
            let description = data["description"] as! String
            let likes = data["likes"] as! Int
            posts.append(Post(id: id, title: title, description: description, likes: likes))
        }
        return posts
    }
    func getCommentsFromPost(postId: String) {
        var comments: [Comment] = []
        let commentsSnapshot = db.collection("posts").document(postId).collection("comments").getDocuments()
        for snapshot in commentsSnapshot.documents {
            let data = snapshot.data()
            let id = snapshot.documentID
            let text = data["text"] as! String
            let likes = data["likes"] as! Int
            comments.append(Comment(id: id, text: text, likes: likes))
        }
        return comments
    }
}
