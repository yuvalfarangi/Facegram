import SwiftUI

struct commentView: View {
    var comment: Comment
    @State private var isLiked: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    userView_sm(userID: comment.user)
                    Spacer()
                }
                HStack {
                    Text(comment.commentText)
                        .padding(.leading, 40)
                    Spacer()
                }
            }
            Spacer()

            Button(action: {
                isLiked.toggle()
                comment.toogleLike(userID: SessionManager.shared.retrieveUserSession()?._id ?? "")
            }) {
                resizeableSymbol(
                    symbolName: isLiked ? "heart.fill" : "heart",
                    size: 15,
                    color: isLiked ? .PrimaryColor : .primary
                )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 5)
        }
        .onAppear {
            isLiked = comment.isLoogedUserLiked()
        }
    }
}
