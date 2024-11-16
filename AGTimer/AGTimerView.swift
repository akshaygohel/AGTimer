//
//  AGTimerView.swift
//  AGTimer
//
//  Created by Akshay Gohel on 2024-11-16.
//

import SwiftUI

struct AGTimerView: View {
    @StateObject private var viewModel = AGTimerViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                AGRingView(progress: 100.0, ringColor: .gray.opacity(0.7))
                    .frame(width: 200, height: 200)
                AGRingView(progress: (viewModel.timeLeft) / INITIAL_TIME)
                    .frame(width: 200, height: 200)
                Text(String(format: "%.1f", viewModel.timeLeft)) // Timer in seconds
                    .font(.largeTitle)
                    .padding()
            }
            Spacer()
            HStack {
                Button(action: {
                    viewModel.startPauseTimer()
                }) {
                    Text(viewModel.isRunning ? "Pause" : "Start")
                        .frame(width: 100, height: 50)
                        .background(viewModel.isRunning ? Color.orange : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.stopTimer()
                }) {
                    Text("Stop")
                        .frame(width: 100, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            // Schedule background task if necessary
            (UIApplication.shared.delegate as? AGAppDelegate)?.scheduleBackgroundTask()
        }
    }
}

struct AGRingView: View {
    var progress: Double
    var ringColor: Color = .blue
    
    var body: some View {
        Circle()
            .trim(from: 0, to: CGFloat(progress))
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .foregroundColor(ringColor)
            .rotationEffect(.degrees(-90))
            .animation(.linear(duration: 0.1), value: progress)
    }
}


