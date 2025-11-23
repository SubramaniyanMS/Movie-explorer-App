//
//  Movie_Explorer_AppApp.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI
import CoreData
import UserNotifications

@main
struct Movie_Explorer_AppApp: App {
    let coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.context)
                .onAppear {
                    requestNotificationPermission()
                }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
}
