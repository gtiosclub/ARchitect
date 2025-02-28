//
//  CommentViewModel.swift
//  ARchitect
//
//  Created by Dhairya Patel on 2/20/25.
//

import SwiftUI

class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []

    func addComment(text: String, publisher: String) {
        let newComment = Comment(text: text, timestamp: Date(), publisher: publisher)
        comments.append(newComment)
    }
}
//class CommentViewModel: ObservableObject {
//    @Published var comments: [Comment] = [
//        Comment(text: "This is a test comment!", timestamp: Date(), publisher: "TestUser")
//    ] // 🔥 Add a default comment
//}
