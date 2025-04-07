//
//  PostViewModel.swift
//  ARchitect
//
//  Created by Dhairya Patel on 4/6/25.
//

import SwiftUI

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []

    init() {
        let post1 = Post(
            username: "rayray123",
            userImage: "person.circle",
            title: "My Lamp Tuff Ain't It",
            imageName: "lamp",
            tags: ["cozy", "lamp", "interior"],
            description: "This lamp gives off the perfect cozy vibes ✨🛋️",
            timeAgo: "3 hours ago",
            likes: 150,
            user_liked: false,
            commentsModel: CommentViewModel(),
            // environment: EnvironmentModel(forPostID: UUID())
        )

        let post2 = Post(
            username: "stunnaboydave",
            userImage: "person.circle.fill",
            title: "Living Room Vase and Things of That Nature",
            imageName: "livingroom",
            tags: ["livingroom", "modern", "minimalist"],
            description: "A modern living room with a clean palette 🪟🪑",
            timeAgo: "5 hours ago",
            likes: 200,
            user_liked: true,
            commentsModel: CommentViewModel(),
            // environment: EnvironmentModel(forPostID: UUID())
        )

        self.posts = [post1, post2]
    }
}

#Preview {
    PostFeedView()
}
