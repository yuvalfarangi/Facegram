import SwiftUI

struct userView_lg: View {
    @State private var tabViewHeight: CGFloat = 300
    var userID: String
    @State private var user: User?
    @State private var isLoading: Bool = true // Loading state
    
    var body: some View {
        VStack {
            if isLoading {
                // Show loading indicator while fetching data
                ProgressView("Loading user...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .font(.headline)
            } else {
                // Show user details after data is fetched
                // Profile Picture and Info
                Image(uiImage: user?.decodedProfilePic ?? UIImage(systemName: "person.fill")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                Text("\(user?.firstName ?? "Unknown") \(user?.lastName ?? "Unknown")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("\(user?.username ?? "Unknown")")
                    .font(.subheadline)
                    .padding(.bottom, 10)
                
                // Dynamic TabView
                TabView {
                    // First Tab
                    tagsView(items: user?.tags ?? [])
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(key: ViewHeightKey.self, value: proxy.size.height)
                            }
                        )
                        .tabItem {
                            Label("Tags", systemImage: "tag.fill")
                        }
                    
                    // Second Tab
                    HStack {
                        counter(name: "Posts", count: user?.posts?.count ?? 0)
                        counter(name: "Followers", count: user?.followers?.count ?? 0)
                        counter(name: "Followings", count: user?.following?.count ?? 0)
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: ViewHeightKey.self, value: proxy.size.height)
                        }
                    )
                    .tabItem {
                        Label("Info", systemImage: "info.circle")
                    }
                }
                .frame(height: tabViewHeight / 2)
                .tabViewStyle(.page)
                .onPreferenceChange(ViewHeightKey.self) { height in
                    tabViewHeight = height
                }
                
                // Additional Information
                Text(user?.bio ?? "No bio available")
                    .padding(.vertical, 10)
                    .font(.body)
            }
        }
        .onAppear {
            Task {
                user = await getUserByID(userID: userID)
                isLoading = false
            }
            
        }
    }
}

// PreferenceKey to measure child view height
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 300
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    userView_lg(userID: "675d95e6e921538e1d5ad878")
}
