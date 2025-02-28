//
//  CommentSectionView.swift
//  ARchitect
//
//  Created by Dhairya Patel on 2/20/25.
//

import SwiftUI

struct CommentSectionView: View {
    @StateObject private var viewModel = CommentViewModel()
    @State private var isExpanded = false
    @State private var newCommentText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header button to toggle comment visibility
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Comments (\(viewModel.comments.count))")
                        .font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
            }

            // Display comments if expanded
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    List(viewModel.comments) { comment in
                        VStack(alignment: .leading) {
                            Text(comment.publisher)
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(comment.text)
                                .font(.body)
                            Text(comment.timestamp, style: .time)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }

                    // Text input for adding new comments
                    HStack {
                        TextField("Add a comment...", text: $newCommentText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button(action: {
                            if !newCommentText.isEmpty {
                                viewModel.addComment(text: newCommentText, publisher: "User123")
                                newCommentText = ""
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
                .transition(.slide)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding()
    }
}

#Preview {
    CommentSectionView()
}
