import SwiftUI

struct notificationView: View {
    
    var notification: notification
    
    // Mapping of events to icon names
    func iconForEvent(_ event: String) -> String {
        switch event {
        case "Like":
            return "heart.fill"
        case "Comment":
            return "speech.bubble.fill"
        case "Follow":
            return "person.fill"
        default:
            return "bell.fill" // Default icon if the event is not matched
        }
    }
    
    func formatTimestamp_Date(_ timestamp: Int) -> String {
        guard(timestamp>0)else{return ""}
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000)) // Convert from milliseconds to seconds
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
            
    }
    
    func formatTimestamp_Hour(_ timestamp: Int) -> String {
        guard(timestamp>0)else{return ""}
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000)) // Convert from milliseconds to seconds
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        HStack{
            Image(systemName: iconForEvent(notification.event))
                .resizable()
                .frame(width: 20, height: 20)
                .padding(10)
                .background(Circle().foregroundColor(.PrimaryColor).opacity(0.5))
                .clipShape(Circle())
                .foregroundColor(.PrimaryColor)
            VStack (alignment: .leading){
                Text(notification.title)
                    .font(.headline)
                Text(notification.body)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            VStack{
                Text(formatTimestamp_Hour(notification.timestamp ?? 0))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Text(formatTimestamp_Date(notification.timestamp ?? 0))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    notificationView(notification: notification(
        event: "Like",
        title: "New Like!",
        body: "User123 liked your post.",
        user: "User123",
        timestamp: 1735906129411
    ))
}
