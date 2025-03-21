//
//  FCM.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 01/01/2025.
//

import SwiftUI
import UserNotifications
import FirebaseMessaging

// Request notification permission and register for FCM token
func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Permission granted for notifications")
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            print("Permission denied for notifications: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}

