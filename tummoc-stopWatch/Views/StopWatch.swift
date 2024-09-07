//
//  ContentView.swift
//  tummoc-stopWatch
//
//  Created by Bholanath Barik on 06/09/24.
//

import SwiftUI

struct StopWatch: View {
    @StateObject var stopWatchModel = StopWatchModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var backgroundEntryTime: Date?
    
    var body: some View {
        VStack(spacing: 30) {
            // Display the elapsed time with a bold and larger font
            Text(formatTime(stopWatchModel.timeElapsed, precision: stopWatchModel.currPrecision))
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                )
            
            // Precision Picker with improved styling
            Picker("Precision", selection: $stopWatchModel.currPrecision) {
                Text("Seconds").tag(Precision.second)
                Text("Milliseconds").tag(Precision.millisecond)
            }
            .padding(.horizontal)
            .onChange(of: stopWatchModel.currPrecision) { _ in
                // Pause and restart when precision changes
                if stopWatchModel.isRunning {
                    stopWatchModel.actionPause()
                    stopWatchModel.actionStart()
                }
            }
            
            // HStack containing Start/Pause and Restart buttons
            HStack(spacing: 20) {
                Button(action: {
                    !stopWatchModel.isRunning ? stopWatchModel.actionStart() : stopWatchModel.actionPause()
                }) {
                    Text(stopWatchModel.isRunning ? "Pause" : "Start")
                        .font(.title2.bold())
                        .frame(width: 140, height: 60)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                
                Button(action: {
                    stopWatchModel.actionRestart()
                }) {
                    Text("Restart")
                        .font(.title2.bold())
                        .frame(width: 140, height: 60)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: Color.red.opacity(0.5), radius: 10, x: 0, y: 5)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background:
                backgroundEntryTime = Date()
                NotificationManager.shared.triggerStopwatchNotification(timeElapsed: formatTime(stopWatchModel.timeElapsed, precision: stopWatchModel.currPrecision))
                startBackgroundTimer()
            case .active:
                backgroundEntryTime = nil
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                stopBackgroundTimer()
            default:
                break
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval, precision: Precision) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 1000)
        
        switch precision {
        case .second:
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        case .millisecond:
            return String(format: "%02d:%02d:%02d:%03d", hours, minutes, seconds, milliseconds)
        }
    }
    
    // Background timer to track background time
    @State private var backgroundTimer: Timer?
    
    private func startBackgroundTimer() {
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: 600, repeats: false) { _ in
            NotificationManager.shared.triggerAlertNotification()
            startResetTimer()
        }
    }
    
    private func stopBackgroundTimer() {
        backgroundTimer?.invalidate()
        backgroundTimer = nil
    }
    
    // Timer to reset stopwatch after 15 minutes in the background
    private func startResetTimer() {
        Timer.scheduledTimer(withTimeInterval: 300, repeats: false) { _ in
            stopWatchModel.actionRestart()
        }
    }
}

#Preview {
    StopWatch()
}
