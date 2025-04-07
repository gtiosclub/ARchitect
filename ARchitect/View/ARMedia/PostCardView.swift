//
//  PostCardView.swift
//  ARchitect
//
//  Created by Dhairya Patel on 4/6/25.
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    @State private var isExpanded = false
    @State private var newCommentText = ""
    @State private var showMenu = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: post.userImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(post.username)
                        .font(.subheadline)
                        .bold()
                    Text(post.timeAgo)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    withAnimation {
                        showMenu.toggle()
                    }
                }) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.primary)
                }
            }

            Image(post.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)

            Text(post.description)
                .font(.body)
                .padding(.horizontal, 2)
                .lineLimit(isExpanded ? nil : 3)

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("\(post.likes > 99 ? "99+" : "\(post.likes)")")
                }

                Spacer()

                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                        Text("\(post.commentsModel.comments.count > 99 ? "99+" : "\(post.commentsModel.comments.count)")")
                    }

                }
            }
            .font(.subheadline)
            .padding(.horizontal, 2)

            if isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(post.commentsModel.comments) { comment in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(comment.publisher)
                                .font(.caption)
                                .bold()
                            Text(comment.text)
                                .font(.body)
                        }
                        .padding(.vertical, 2)
                    }

                    HStack {
                        TextField("Add a comment...", text: $newCommentText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button(action: {
                            if !newCommentText.isEmpty {
                                post.commentsModel.addComment(text: newCommentText, publisher: post.username)
                                newCommentText = ""
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }

            if showMenu {
                VStack(spacing: 4) {
                    Divider()
                    Text("Option 1")
                    Text("Option 2")
                    Text("Option 3")
                }
                .font(.caption)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

#Preview {
    let dummyPost = Post(
        username: "preview_user",
        userImage: "person.circle",
        title: "Preview Post",
        imageName: "sampleImage",
        tags: ["cozy", "modern"],
        description: "This is a sample post showcasing beautiful design, cozy lighting, and modern aesthetic.",
        timeAgo: "2 hours ago",
        likes: 120,
        user_liked: false,
        commentsModel: CommentViewModel()
    )

    PostCardView(post: dummyPost)
}
