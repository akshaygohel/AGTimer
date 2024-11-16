//
//  AGTimerApp.swift
//  AGTimer
//
//  Created by Akshay Gohel on 2024-11-16.
//

import BackgroundTasks
import SwiftUI

@main
struct AGTimerApp: App {
    @UIApplicationDelegateAdaptor(AGAppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AGTimerView()
                .onAppear {
                    AGNotificationManager.shared.requestNotificationPermission()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    appDelegate.scheduleBackgroundTask()
                }
        }
    }
}
