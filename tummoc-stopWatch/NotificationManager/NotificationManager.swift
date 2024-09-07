//
//  NotificationManager.swift
//  tummoc-stopWatch
//
//  Created by Bholanath Barik on 07/09/24.
//

import Foundation

import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        setupNotificationActions()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    private func setupNotificationActions() {
        let startPauseAction = UNNotificationAction(identifier: "START_PAUSE_ACTION", title: "Start/Pause", options: [])
        let resetAction = UNNotificationAction(identifier: "RESET_ACTION", title: "Reset", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "STOPWATCH_CATEGORY",
                                              actions: [startPauseAction, resetAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func triggerStopwatchNotification(timeElapsed: String) {
        let content = UNMutableNotificationContent()
        content.title = "Stopwatch Running"
        content.body = "Elapsed Time: \(timeElapsed)"
        content.categoryIdentifier = "STOPWATCH_CATEGORY"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "stopwatchNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func triggerAlertNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Stopwatch Alert"
        content.body = "Stopwatch will be reset in 5 minutes if not opened."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "alertNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "START_PAUSE_ACTION":
            print("Start/Pause action triggered")
        case "RESET_ACTION":
            print("Reset action triggered")
        default:
            break
        }
        completionHandler()
    }
}
