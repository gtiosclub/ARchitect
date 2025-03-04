//
//  PostView.swift
//  ARchitect
//
//  Created by Amiire kolawole on 2025-03-03.
//

import SwiftUI

struct PostView: View {
    let post: Post

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // User Info and Options
                HStack {
                    Image(systemName: post.userImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(post.username)
                        .font(.headline)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // AR Image with Overlays
                NavigationLink(destination: ARFeedView()) {
                    ZStack(alignment: .topLeading) {
                        Image(post.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                        
                        // Cube Icon at Bottom Right
                        HStack {
                            Spacer()
                            Image(systemName: "cube.transparent.fill")
                                .font(.title)
                                .foregroundColor(.black.opacity(0.8))
                                .padding()
                        }
                    }
                }
                
                // Title & Tags
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(post.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        Button(action: {
                            print("Options tapped")
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                    HStack {
                        let colors: [Color] = [.red, .green, .blue, .orange, .purple]
                        
                        ForEach(post.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(colors[post.tags.firstIndex(of: tag)! % colors.count].opacity(0.2)) // Cycle through colors
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Description
                Text(post.description)
                    .font(.body)
                    .padding(.horizontal)
                
                // Time Ago
                Text(post.timeAgo)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                // Comment Box & Like Button
                HStack {
                    TextField("Comment something...", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 40)
                    
                    Button(action: {
                        print("Liked post")
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}


#Preview {
    PostView(
        post:Post(
            username: "username",
            userImage: "person.circle.fill", // SF Symbol for user avatar
            title: "1990 Vintage",
            imageName: "ar_room1", // Replace with actual asset name
            tags: ["vintage", "retro", "vibe"],
            description: "Bold interior design project that revives the vibrant energy of the early '80s. It marries vivid color schemes, geometric patterns, and nostalgic accents with contemporary comforts.",
            timeAgo: "4 days ago",
            likes: 120,
            comments: 100)
         )
}
