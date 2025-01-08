import SwiftUI
import UIKit

struct ImageResponse: Decodable {
    let encodedImage: String
}

struct updatesScreen: View {
    
    @State private var notifications: [notification] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack {
            
            VStack {
                if isLoading {
                    ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
                } else {
                    
                    if(notifications.isEmpty) {
                        Text("No updates")
                    }else{
                        List {
                            ForEach(notifications, id: \.self) { notification in
                                notificationView(notification: notification)
                            }
                        }
                    }
                }
            }.navigationTitle("Updates")
        }
        .onAppear {
            Task {
                do {
                    let res = try await getNotifications()
                    notifications = res
                    print(notifications)
                    isLoading = false
                } catch {
                    print("Error fetching notifications:", error)
                    isLoading = false
                }
            }
        }
    }
}


#Preview {
    updatesScreen()
}
