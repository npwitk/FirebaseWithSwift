//
//  FirebaseWithSwiftApp.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 21/3/25.
//

import SwiftUI
import Firebase

@main
struct FirebaseWithSwiftApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Configured Firebase!")
        return true
    }
}
