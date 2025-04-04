import SwiftUI

struct CommentSectionView: View {
    @Binding var viewModel: CommentViewModel
    @State private var newCommentText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // List of comments
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.comments) { comment in
                    HStack(alignment: .top, spacing: 12) {
                        // Profile picture (grey circle)
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 40, height: 40)
                        
                        // Comment text
                        VStack(alignment: .leading, spacing: 4) {
                            Text(comment.publisher)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(comment.text)
                                .font(.body)
                        }
                        
                        Spacer()
                        
                        // Like button and like count
                        VStack {
                            Button(action: {
                                viewModel.toggleLike(for: comment)
                            }) {
                                Image(systemName: comment.isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(comment.isLiked ? .pink : .gray)
                                    .font(.title2)
                            }
                            
                            Text("\(comment.likes)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .cornerRadius(12)
            
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
        .padding(.top)
    }
}

#Preview {
    @Previewable @State var commentViewModel = CommentViewModel()
    
    CommentSectionView(viewModel: $commentViewModel)
}
