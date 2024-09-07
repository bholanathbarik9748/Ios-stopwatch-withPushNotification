//
//  tummoc_stopWatchApp.swift
//  tummoc-stopWatch
//
//  Created by Bholanath Barik on 06/09/24.
//

import SwiftUI
import UserNotifications

@main
struct tummoc_stopWatchApp: App {
    init() {
        NotificationManager.shared.requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            StopWatch()
        }
    }
}
