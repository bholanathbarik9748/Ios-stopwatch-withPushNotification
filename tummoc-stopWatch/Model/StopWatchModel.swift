//
//  stopWatchModel.swift
//  tummoc-stopWatch
//
//  Created by Bholanath Barik on 06/09/24.
//

import Foundation

class StopWatchModel: ObservableObject {
    @Published var timeElapsed : TimeInterval = 0;
    @Published var isRunning : Bool = false;
    var currPrecision: Precision = .second;
    var timer : Timer?
    
    
    func actionStart() {
        self.isRunning = true;
        let currentInterval = (self.currPrecision == .second ? 1.0 : 0.01);
        timer = Timer.scheduledTimer(withTimeInterval:  currentInterval, repeats: true) { _ in
            self.timeElapsed += currentInterval;
        }
    }
    
    func actionPause() {
        self.isRunning = false;
        timer?.invalidate()
        timer = nil;
    }
    
    func actionRestart() {
        actionPause()
        timeElapsed = 0;
    }
}

enum Precision {
    case second
    case millisecond
}
