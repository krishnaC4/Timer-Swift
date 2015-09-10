//
//  PresetTimer.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import Foundation

func ==(lhs: TimedEvent, rhs: TimedEvent) -> Bool {
   return lhs.name == rhs.name && lhs.timeInterval == rhs.timeInterval
}

protocol TimeRepresentable {
    var timeInterval: NSTimeInterval { get }
}

protocol TimeDescribable {
    var name: String { get }
    func description(format: TimeUnit, milliseconds: Bool) -> String
}

struct TimedEvent: Equatable, TimeRepresentable, TimeDescribable {
    
    var timeInterval: NSTimeInterval
    var name: String
    
    func description(format: TimeUnit, milliseconds: Bool = false) -> String {
        return TimeFormatter.format(timeInterval, format: format, milliseconds: milliseconds)
    }
    
    static func defaultPresetTimers() -> [TimedEvent] {
        return [
            popcornTimer(),
            bakedPotatoTimer(),
            runningTimer(),
            napTimer()
        ]
    }
    
    static func popcornTimer() -> TimedEvent {
        return TimedEvent(timeInterval: 60 * 3.0, name: "Popcorn")
    }
    
    static func bakedPotatoTimer() -> TimedEvent {
        return TimedEvent(timeInterval: 60 * 5.0, name: "Baked Potato")
    }
    
    static func runningTimer() -> TimedEvent {
        return TimedEvent(timeInterval: 60 * 15.0, name: "Running")
    }
    
    static func napTimer() -> TimedEvent {
        return TimedEvent(timeInterval: 60 * 20.0, name: "Nap")
    }
}