//
//  Kifa_Plus__1_App.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 15/04/24.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    @main
    struct Kifa_Plus__1_App: App {
        
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
    }
}
