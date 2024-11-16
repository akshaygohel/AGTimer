//
//  AGNotificationManager.swift
//  AGTimer
//
//  Created by Akshay Gohel on 2024-11-16.
//

import UserNotifications

class AGNotificationManager {
    static let shared = AGNotificationManager()
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if !granted {
                print("Permission denied.")
            }
        }
    }
    
    func sendLocalNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Timer Ended"
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
