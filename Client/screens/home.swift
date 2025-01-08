//
//  homeScreen.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 29/11/2024.
//

import SwiftUI

struct homeScreen: View {
    
    @State private var isLoading: Bool = true
    @State var posts: [Post] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                logoMD()
                
                if(isLoading){
                    ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
                }else{
                    
                    if(posts.isEmpty){
                        
                        
                        VStack{
                            Text("No posts yet")
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundColor(.gray)
                            Text("Start Exploring!")
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundStyle(
                                    LinearGradient(gradient: Gradient(colors: [.logoColors_lightOrange, .logoColors_orange, .logoColors_pink]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                        }
                        
                        
                    }else{
                        ForEach(posts, id: \._id) { post in
                            PostView_lg(initialPost: post)
                        }
                    }
                }
            }.onAppear {
                Task {
                    var fetchedPosts: [Post] = []  // Temporary array to store unique posts
                    
                    // Step 1: Fetch posts for each user in the following list
                    for user in await SessionManager.shared.retrieveUserSession()?.getFollowing() ?? [] {
                        let userPosts = await user.getRecentPosts(days: 10)
                        
                        // Step 2: Filter out duplicates by checking _id
                        for post in userPosts {
                            // Only append if the post's _id is not already in the fetchedPosts array
                            if !fetchedPosts.contains(where: { $0._id == post._id }) {
                                fetchedPosts.append(post)
                            }
                        }
                    }
                    
                    // Step 3: Update the posts array with the unique posts
                    posts = fetchedPosts
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    homeScreen()
}
