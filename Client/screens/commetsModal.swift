//
//  commetsModal.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 30/11/2024.
//

import SwiftUI

struct CommentsModal: View {
    
    @State private var newCommentText: String = ""
    @State private var isLoading: Bool = true
    @State private var post: Post?
    @State private var comments: [Comment] = []
    var postID: String
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
            } else {
                VStack {
                    HStack {
                        Text("Comments")
                            .font(.headline)
                        Spacer()
                    }.padding()
                    
                    List {
                        ForEach(comments, id: \.self) { comment in
                            commentView(comment: comment)
                                .swipeActions(edge: .leading) {
                                    if( comment.isLogedUserAuthor()){
                                        Button(role: .destructive) {
                                            comment.delete()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                        }
                    }
                    
                    HStack {
                        TextField("Add a comment", text: $newCommentText)
                            .onSubmit {
                                addComment()
                            }
                        
                        resizeableSymbol(symbolName: "plus.circle.fill", size: 25, onPress: addComment, color: .PrimaryColor)
                    }.padding()
                }
            }
        }
        .onAppear {
            Task {
                post = await getPostByID(postID: postID)
                isLoading = false
                comments = post?.comments ?? []
                
            }
        }
    }
    
    func addComment() {
        guard let userId = SessionManager.shared.retrieveUserSession()?._id else { return }
        let newComment = Comment(
            user: userId,
            post: postID,
            commentText: newCommentText
        )
        
        Task {
            newComment.add()
            comments.append(newComment)
            newCommentText = ""  // Clear the input field after adding the comment
        }
    }
}

#Preview {
    CommentsModal(postID: "6766e4fbf358d7199b63e2d1")
}
