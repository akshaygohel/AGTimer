//
//  AGTimerViewModel.swift
//  AGTimer
//
//  Created by Akshay Gohel on 2024-11-16.
//

import Foundation
import Combine
import UIKit

let INITIAL_TIME = 60.0 // Time in seconds (including milliseconds)

class AGTimerViewModel: ObservableObject {
    
    @Published var timeLeft: Double = 0.0
    @Published var isRunning: Bool = false
    
    private var isPaused: Bool = false
    private var timerCancellable: AnyCancellable?
    private var updateInterval: TimeInterval = 0.1  // Update interval for milliseconds
    private var timerEndDate: Date?
    
    init() {
        self.stopTimer()
    }
    
    func startPauseTimer() {
        if isRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    private func pauseTimer() {
        timerCancellable?.cancel()
        isPaused = true
        isRunning = false
    }
    
    func stopTimer() {
        stopTimerInternal()
        timeLeft = INITIAL_TIME
    }
    
    func stopTimerInternal() {
        timerCancellable?.cancel()
        isRunning = false
    }
    
    func startTimer() {
        if !isPaused {
            timeLeft = INITIAL_TIME
        }
        isPaused = false
        isRunning = true
        
        // Set timer end date for background task scheduling
        timerEndDate = Date().addingTimeInterval(timeLeft)
        
        timerCancellable = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // Decrement timeLeft but ensure it doesn't go below zero
                if self.timeLeft > self.updateInterval {
                    self.timeLeft -= self.updateInterval
                } else {
                    self.timeLeft = 0 // Ensure time doesn't go negative
                    self.stopTimerInternal()
                    self.sendCompletionNotification() // Notify when the timer ends
                }
                
//                // Schedule the background task if the app goes to the background before the timer ends
//                if let timerEndDate = self.timerEndDate, Date() >= timerEndDate {
//                    (UIApplication.shared.delegate as? AGAppDelegate)?.scheduleBackgroundTask()
//                }
            }
    }
    
    private func sendCompletionNotification() {
        // Send a local notification when the timer finishes
        AGNotificationManager.shared.sendLocalNotification(message: "Timer Complete!")
    }
}
