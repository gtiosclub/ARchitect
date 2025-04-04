//
//  ARMediaView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI

struct ARMediaView: View {
    @State var posts: [Post] = [
        Post(
            username: "username",
            userImage: "person.circle.fill", // SF Symbol for user avatar
            title: "1990 Vintage",
            imageName: "ar_room1", // Replace with actual asset name
            tags: ["vintage", "retro", "vibe"],
            description: "Bold interior design project that revives the vibrant energy of the early '80s. It marries vivid color schemes, geometric patterns, and nostalgic accents with contemporary comforts.",
            timeAgo: "4 days ago",
            likes: 120),
        Post(
            username: "Bob",
            userImage: "person.circle.fill", // SF Symbol for user avatar
            title: "Virtual Office",
            imageName: "ar_room2", // Replace with actual asset name
            tags: ["vintage", "retro"],
            description: "Bold interior design project that revives the vibrant energy of the early '80s. It marries vivid color schemes, geometric patterns, and nostalgic accents with contemporary comforts.",
            timeAgo: "10 days ago",
            likes: 100),
    ]
    var body: some View {
        NavigationStack {
            VStack {
                Text("ARchitect")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(posts) { post in
                            if let binding = bindingForPost(id: post.id) {
                                NavigationLink(destination: PostView(post: binding)) {
                                    SubARView(post: binding)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    private func bindingForPost(id: UUID) -> Binding<Post>? {
        guard let index = posts.firstIndex(where: { $0.id == id}) else { return nil}
        return $posts[index]
    }
    
}

#Preview {
    ARMediaView()
}

struct SubARView: View {
    @Binding var post:Post
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                // AR Image with rounded corners and overlay
                Image(post.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .overlay(
                        // Gradient Overlay for Text Readability
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black.opacity(0.8)]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .cornerRadius(15)
                    )
                
                // Overlay Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: post.userImage)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        
                        Text(post.username)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    Text(post.description)
                        .font(.caption)
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                .padding()
            }
            .padding(.horizontal)
            
            // Interaction Bar
            HStack {
                Button(action: {
                    post.toggleLike()
                }) {
                    HStack {
                        Image(systemName: post.user_liked ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                        Text("\(post.likes)+")
                    }
                }
                
                Button(action: {
                    post.addComment(text: "New Comment!", publisher: "AnonymousUser")
                }) {
                    HStack {
                        Image(systemName: "ellipsis.message")
                        Text("\(post.commentsModel.length())+")
                    }
                }
                
                Text("\(post.timeAgo)")
                    .font(.caption)
                    .padding(.leading, 30)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .foregroundColor(.black) // Set the text color to grey
    }
}
