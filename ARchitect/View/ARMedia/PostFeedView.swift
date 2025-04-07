//
//  PostFeedView.swift
//  ARchitect
//
//  Created by Dhairya Patel on 4/6/25.
//

import SwiftUI

struct PostFeedView: View {
    @StateObject private var viewModel = PostViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("profile-placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())

                Spacer()

                Text("ARchitect")
                    .font(.title3)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 6)
            .background(Color(UIColor.systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 1, y: 1)

            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.posts) { post in
                        PostCardView(post: post)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemBackground))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 80)
            }
            
            HStack {
                Spacer()
                Image(systemName: "house.fill")
                Spacer()
                NavigationLink(destination: Text("Create AR View")) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                }
                Spacer()
                Image(systemName: "square.grid.2x2.fill")
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 0))
            .shadow(radius: 2)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    PostFeedView()
}
