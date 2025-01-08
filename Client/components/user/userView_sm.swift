import SwiftUI

struct userView_sm: View {
    var userID: String
    @State private var user: User?
    @State private var isLoading: Bool = true // Loading state
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        HStack {
            if isLoading {
                // Placeholder content during loading
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 30, height: 30)
                Text("Loading...")
                    .font(.headline)
            } else {
                // Main content after loading
                if let user = user {
                    NavigationLink(destination: ProfileScreen(isLoggedIn: $isLoggedIn, user: user)) {
                        HStack {
                            Image(uiImage: user.decodedProfilePic ?? UIImage(systemName: "person.fill")!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.headline)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.primary)
                } else {
                    // Fallback UI if user data is not available
                    Text("User data unavailable")
                        .font(.headline)
                }
            }
        }
        .onAppear {
            Task {
                user = await getUserByID(userID: userID)
                isLoading = false
            }
        }
        .tint(.primary)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    userView_sm(userID: "675d95e6e921538e1d5ad878")
}
