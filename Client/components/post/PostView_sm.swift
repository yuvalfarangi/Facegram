//
//  PostView_sm.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 06/12/2024.
//

import SwiftUI

struct PostView_sm: View {
    var screenSize = UIScreen.main.bounds.width / 3 - 17
    var postID: String
    @State private var post: Post?
    @State private var user: User?
    @State private var isLoading: Bool = true
    
    var body: some View {
        
        NavigationLink(destination: PostView_lg(postID: postID)) {
            VStack {
                if isLoading {
                    ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
                } else {
                    Image(uiImage: post?.decodedMedia ?? UIImage(systemName: "person.fill")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenSize, height: screenSize)
                        .cornerRadius(10)
                }
            }
        }
        
        .onAppear {
            Task{
                post = await getPostByID(postID: postID)
                isLoading = false
            }
        }
    }
}

#Preview {
    PostView_sm(postID: "6766e4fbf358d7199b63e2d1")
}
