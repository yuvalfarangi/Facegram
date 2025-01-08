//
//  notification.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 01/01/2025.
//

import Foundation

struct notification: Codable, Hashable{
    
    let id: String?
    let event: String
    let title: String
    let body: String
    let user: String
    let timestamp: Int?
    
    init(id: String? = "",event: String, title: String, body: String, user: String, timestamp: Int? = nil){
        self.id = id
        self.event = event
        self.title = title
        self.body = body
        self.user = user
        self.timestamp = timestamp
    }
}

func getNotifications() async throws -> [notification] {
    guard let loggedInUser = SessionManager.shared.retrieveUserSession(),
          let userId = loggedInUser._id else {
        throw NSError(domain: "SessionError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User session is not available"])
    }
    
    guard let notifications = await ServerAPI.shared.fetchData(
        endpoint: "/notifications/\(userId)",
        responseType: [notification].self
    ) else {
        throw NSError(domain: "DataError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch notifications"])
    }
    
    return notifications
}
