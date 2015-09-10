//
//  Timer.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import Foundation

protocol TimerDelegate: class {
    func timerDidFire(timer: Timer)
}

class Timer: NSObject {
    
    // public
    
    weak var delegate: TimerDelegate?
    private(set) var elapsedTime: NSTimeInterval = 0
    
    // private
    
    private var internalTimer: NSTimer?
    private var previousTime: NSDate?
    private var timeInterval: NSTimeInterval = 1/60
    
    override init() {
        super.init()
    }
    
    init(timeInterval: NSTimeInterval) {
        super.init()
        self.timeInterval = timeInterval
        self.reset()
    }
    
    func description(format: TimeUnit, milliseconds: Bool = false) -> String {
        return TimeFormatter.format(elapsedTime, format: .Minutes, milliseconds: milliseconds)
    }
    
    func start() {
        previousTime = NSDate()
        internalTimer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
    }
    
    func stop() {
        internalTimer?.invalidate()
    }
    
    @objc private func timerFired(timer: NSTimer) {
        if let previousTime = previousTime {
            let elapsed = fabs(previousTime.timeIntervalSinceNow)
            self.elapsedTime += elapsed
            self.previousTime = NSDate()
            
            delegate?.timerDidFire(self)
        }
    }
    
    private func reset() {
        elapsedTime = 0.0
        internalTimer?.invalidate()
    }
}