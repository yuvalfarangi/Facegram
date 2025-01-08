import SwiftUI

struct ContentView: View {
    
    @State private var loggedInUser: User?
    
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack{
            if !isLoggedIn {
                entryScreen(loggedInUser: $loggedInUser, isLoggedIn: $isLoggedIn)
            }else{
                
                TabView {
                    homeScreen().tabItem {
                        VStack {
                            Text("Home")
                            Image(systemName: "house.fill")
                        }
                    }
                    searchScreen().tabItem {
                        VStack {
                            Text("Explore")
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    uploadScreen().tabItem {
                        VStack {
                            Text("Upload")
                            Image(systemName: "plus.square.fill")
                        }
                    }
                    updatesScreen().tabItem {
                        VStack {
                            Text("Updates")
                            Image(systemName: "heart.fill")
                        }
                    }
                    
                    ProfileScreen(isLoggedIn: $isLoggedIn, user: loggedInUser!).tabItem {
                        VStack {
                            Text("Profile")
                            Image(systemName: "person.fill")
                        }
                    }
                }
                .tint(.PrimaryColor)
            }
        }.onAppear {
            loggedInUser = SessionManager.shared.retrieveUserSession()
            if(loggedInUser != nil) {
                isLoggedIn = true
            }
        }
    }
}

#Preview {
    ContentView()
}
