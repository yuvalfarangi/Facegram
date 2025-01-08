//
//  Profile.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 29/11/2024.
//
import SwiftUI

struct ProfileScreen: View {
    
    @Binding var isLoggedIn: Bool
    
    @State var user: User
    @State var loggedinUser: User?
    @State var isFollowing: Bool = true
    @State var editProfileScreenisPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                if(user.isLoggedIn()) {
                    HStack{
                        Spacer()
                        Menu {
                            Button("Log Out", action: {
                                isLoggedIn = false
                                SessionManager.shared.clearUserSession()
                            })
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.primary)
                        }.padding()
                    }
                }
                
                userView_lg(userID: user._id ?? "")
                    .padding(.top, 15)
                
                if(user.isLoggedIn()) {
                    primaryButton(
                        onPress: {editProfileScreenisPresented.toggle()},
                        text: "Edit Profile",
                        symbolName: "pencil")
                }else{
                    primaryButton(
                        onPress: {
                            if (loggedinUser != nil) { loggedinUser?.toggleFollow(user: &user)}
                            isFollowing.toggle()
                        },
                        text: isFollowing ? "Following" : "Follow",
                        symbolName: isFollowing ? "checkmark.circle.fill" :"plus.circle.fill"
                    )
                }
                
                postsGridView(posts: user.posts ?? []).padding(.vertical, 15)
            }.sheet(isPresented: $editProfileScreenisPresented, content: {
                editProfile(isPresented: $editProfileScreenisPresented, userID: user._id!)
                    .presentationDetents([.large])
            })
        }.onAppear {
            print(user)
            loggedinUser = SessionManager.shared.retrieveUserSession()
            if let loggedUser = loggedinUser {
                isFollowing = loggedUser.isFollowing(user: user)
            }
        }
    }
}

#Preview {
    @State var isLoggedIn: Bool = true
    if let sessionUser = SessionManager.shared.retrieveUserSession() {
        ProfileScreen(isLoggedIn: $isLoggedIn, user: sessionUser)
    }
}
