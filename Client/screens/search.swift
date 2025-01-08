//
//  search.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 29/11/2024.
//
import SwiftUI

struct searchScreen: View {
    @State private var searchText: String = "" // State for search input
    @State private var users: [User] = [] // Fetched users
    @State private var isLoading: Bool = true // Loading state
    @State private var posts = Set<String>() //posts id's
    
    var filteredItems: [User] {
        // Filter users based on search text
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.username.contains(searchText) } // Match substring
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if isLoading {
                    // Show progress view while loading
                    ProgressView("Loading...")
                } else if searchText.isEmpty {
                    // Show postsGridView and tags when no search text
                    VStack {
                        tagsView(items: SessionManager.shared.retrieveUserSession()?.tags ?? [])
                        
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
                            postsGridView(posts: Array(posts))
                        }
                        
                    }
                } else if filteredItems.isEmpty {
                    // Handle no results case
                    Text("No users found")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    // Show filtered user list
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(filteredItems, id: \.self) { user in
                            if let userID = user._id {
                                userView_sm(userID: userID)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Explore")
        }
        .searchable(text: $searchText, prompt: "Explore on Facegram")
        .onAppear {
            Task {
                isLoading = true
                
                // Fetch users when the view appears
                users = await getAllUsers() ?? []
                
                let userTags = SessionManager.shared.retrieveUserSession()?.tags ?? []
                
                for tag in userTags {
                    let fetchedPosts = await getPostsByTag(tag: tag)
                    posts.formUnion(fetchedPosts)
                }
                
                isLoading = false
            }
        }
    }
}

#Preview {
    searchScreen()
}
