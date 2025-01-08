import SwiftUI

struct PostView_lg: View {
    @State private var CommentsSheetIsPresented: Bool = false
    @State public var isLiked: Bool = false
    var postID: String?
    var initialPost: Post? // Pass an optional post object
    @State private var post: Post?
    @State private var user: User?
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
            } else {
                // Main content of the view
                VStack {
                    HStack {
                        userView_sm(userID: post?.user ?? "")
                        Spacer()
                        
                        Menu {
                            Button("Save", action: {})
                            Button("View Profile", action: {})
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    Image(uiImage: post?.decodedMedia ?? UIImage(systemName: "person.fill")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    HStack {
                        resizeableSymbol(
                            symbolName: isLiked ? "heart.fill" : "heart",
                            size: 25,
                            onPress: { likePost() },
                            color: isLiked ? .PrimaryColor : .primary
                        )
                        .padding(.horizontal, 5)
                        
                        resizeableSymbol(
                            symbolName: "message",
                            size: 25,
                            onPress: { CommentsSheetIsPresented.toggle() }
                        )
                        .padding(.horizontal, 5)
                        
                        ShareLink(
                            item: URL(string: "https://www.facegram/post/\(postID ?? "")")!, // Fake URL
                            label: {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.primary)
                            }
                        )
                        
                        Spacer()
                    }
                    .padding(8)
                    
                    Text(post?.caption ?? "Post Caption")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.2))
                                .frame(maxWidth: .infinity)
                        )
                        .padding(.horizontal, 7)
                        .padding(.bottom, 7)
                    
                    tagsView(items: post?.tags ?? [])
                }
                .sheet(isPresented: $CommentsSheetIsPresented, content: {
                    CommentsModal(postID: postID ?? post?._id ?? "")
                        .presentationDetents([.large, .medium])
                })
            }
        }
        .padding(.vertical,10)
        .onAppear {
            Task {
                if let initialPost = initialPost {
                    self.post = initialPost
                    if let userSession = SessionManager.shared.retrieveUserSession() {
                        self.isLiked = initialPost.isLikedByUser(user: userSession)
                    }
                    self.isLoading = false
                } else if let postID = postID {
                    // Fetch the post object using postID
                    self.post = await getPostByID(postID: postID)
                    if let userSession = SessionManager.shared.retrieveUserSession() {
                        self.isLiked = post?.isLikedByUser(user: userSession) ?? false
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    private func likePost() {
        post?.toggleLike(user: SessionManager.shared.retrieveUserSession()!)
        isLiked.toggle()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    PostView_lg(postID: "6766e4fbf358d7199b63e2d1", initialPost: nil)
}
