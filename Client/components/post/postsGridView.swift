//
//  postsGridView.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 06/12/2024.
//

import SwiftUI

struct postsGridView: View {
    var posts: [String]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()), 
                GridItem(.flexible())
            ]) {
                ForEach(posts, id: \.self) { post in
                    PostView_sm(postID: post)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    postsGridView(posts: [
        "6766e4fbf358d7199b63e2d1"
    ])
}

