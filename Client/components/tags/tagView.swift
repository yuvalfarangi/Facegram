import SwiftUI

struct tagView: View {
    let text: String
    @State private var loggedInUser: User?

    var body: some View {
        Menu {
            if let user = loggedInUser, user.isTagExist(tag: text) {
                Button(action: {
                    loggedInUser?.toggleTag(tag: text)
                }) {
                    Label("Remove Tag", systemImage: "minus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            } else {
                Button(action: {
                    loggedInUser?.toggleTag(tag: text)
                }) {
                    Label("Add Tag", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        } label: {
            Text(text)
                .font(.system(size: 15))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .onAppear {
            // Safely retrieve logged-in user session
            if let user = SessionManager.shared.retrieveUserSession() {
                loggedInUser = user
            } else {
                print("No logged-in user found")
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    tagView(text: "Programming")
}
