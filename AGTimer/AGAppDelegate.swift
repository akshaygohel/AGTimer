//
//  AGAppDelegate.swift
//  AGTimer
//
//  Created by Akshay Gohel on 2024-11-16.
//

import UIKit
import BackgroundTasks

class AGAppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Register the background task when the app launches
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.AGTimer.timerTask", using: nil) { task in
            // Handle background task completion
            self.handleTimerCompletionTask(task: task)
        }
        
        return true
    }
    
    func handleTimerCompletionTask(task: BGTask) {
        // Send notification when timer ends in the background
        AGNotificationManager.shared.sendLocalNotification(message: "Timer ended in the background!")
        task.setTaskCompleted(success: true)
    }
    
    func scheduleBackgroundTask() {
        // Schedule the background task to trigger after the timer ends
        let request = BGProcessingTaskRequest(identifier: "com.AGTimer.timerTask")
        
        // Ensure the background task occurs after the timer ends (e.g., after 60 seconds)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1.0) // Timer will finish in 60 seconds
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to schedule background task: \(error)")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // When the app enters the background, schedule the background task
        scheduleBackgroundTask()
    }
}
