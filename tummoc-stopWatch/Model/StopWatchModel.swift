//
//  stopWatchModel.swift
//  tummoc-stopWatch
//
//  Created by Bholanath Barik on 06/09/24.
//

import Foundation
import UIKit

class StopWatchModel: ObservableObject {
    @Published var timeElapsed : TimeInterval = 0;
    @Published var isRunning : Bool = false;
    var currPrecision: Precision = .second;
    var timer : Timer?
    
    // background Tasking
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    
    func actionStart() {
        self.isRunning = true;
        let currentInterval = (self.currPrecision == .second ? 1.0 : 0.01);
        timer = Timer.scheduledTimer(withTimeInterval:  currentInterval, repeats: true) { _ in
            self.timeElapsed += currentInterval;
        }
        startBackgroundTask();
    }
    
    func actionPause() {
        self.isRunning = false;
        timer?.invalidate()
        timer = nil;
        endBackgroundTask();
    }
    
    func actionRestart() {
        actionPause()
        timeElapsed = 0;
    }
    
    private func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "StopwatchBackgroundTask") {
            // End the task if time expires
            self.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}

enum Precision {
    case second
    case millisecond
}
