//
//  AppDelegate.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 01/01/2025.
//

import Firebase
import UserNotifications
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    // This method will be called when the app successfully registers with APNs
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass the device token to Firebase
        Messaging.messaging().apnsToken = deviceToken
        print("Device Token: \(deviceToken.hexString)")
    }

    // This method will be called if registration for push notifications fails
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for push notifications: \(error.localizedDescription)")
    }

    // Called when the app finishes launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self

        return true
    }

    // Handle notifications while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification received in foreground: \(notification.request.content.body)")
        completionHandler([.banner, .badge, .sound])
    }

    // Handle actions when the user taps on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User tapped the notification: \(response.notification.request.content.body)")
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "No FCM token available")")
        
    }
}

// Extension to convert device token data to a hex string
extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", $0) }.joined()
    }
}
