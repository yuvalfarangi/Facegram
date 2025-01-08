//
//  FaceGram_IOSApp.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 25/11/2024.
//

import SwiftUI
import Firebase

@main
struct FaceGram_IOSApp: App {
    
    init(){
        FirebaseApp.configure()
        print("Firebase App Initialized")
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

