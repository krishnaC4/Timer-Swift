//
//  TimerFormatter.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import Foundation

enum TimeUnit {
    case Seconds
    case Minutes
    case Hours
    case Days
}

struct TimeFormatter {
    static func format(time: NSTimeInterval, format: TimeUnit, milliseconds: Bool = false) -> String {
        switch format {
        case .Seconds:
            return "\(formattedSeconds(time, milliseconds: milliseconds))"
        case .Minutes:
            return "\(formattedMinutes(time)):\(formattedSeconds(time, milliseconds: milliseconds))"
        case .Hours:
            if "\(formattedHours(time))" == "00" {
                return "\(formattedMinutes(time)):\(formattedSeconds(time, milliseconds: milliseconds))"
            } else {
                return "\(formattedHours(time)):\(formattedMinutes(time)):\(formattedSeconds(time, milliseconds: milliseconds))"
            }
        case .Days:
            return "\(formattedDays(time))d \(formattedHours(time))h \(formattedMinutes(time))m \(formattedSeconds(time))s"
        }
    }
    
    private static func formattedSeconds(time: NSTimeInterval, milliseconds: Bool = false) -> String {
        let s = wrappedSeconds(time)
        let f = milliseconds ? String(format: "%.2f", s)  : String(format: "%d", Int(s))
        if s < 10 {
          return String(format: "0%@", f)
        } else {
          return String(format: "%@", f)
        }
    }
    
    private static func formattedMinutes(time: NSTimeInterval, raw: Bool = false) -> String {
        let m = raw ? rawMinutes(time) : wrappedMinutes(time)
        if m < 10 {
            return String(format: "0%d", Int(m))
        } else {
            return String(format: "%d", Int(m))
        }
    }
    
    private static func formattedHours(time: NSTimeInterval, raw: Bool = false) -> String {
        let h = raw ? rawHours(time) : wrappedHours(time)
        if h < 10 {
            return String(format: "0%d", Int(h))
        } else {
            return String(format: "%d", Int(h))
        }
    }
    
    private static func formattedDays(time: NSTimeInterval, raw: Bool = false) -> String {
        let d = rawDays(time)
        if d < 10 {
            return String(format: "0%d", Int(d))
        } else {
            return String(format: "%d", Int(d))
        }
    }
    
    private static func wrappedSeconds(time: NSTimeInterval) -> NSTimeInterval {
        return fmod(time, 60)
    }
    
    private static func rawMinutes(time: NSTimeInterval) -> NSTimeInterval {
       return floor(time / 60.0);
    }
    
    private static func wrappedMinutes(time: NSTimeInterval) -> NSTimeInterval {
        return fmod(rawMinutes(time), 60)
    }
    
    private static func rawHours(time: NSTimeInterval) -> NSTimeInterval {
        return floor(rawMinutes(time) / 60)
    }
    
    private static func wrappedHours(time: NSTimeInterval) -> NSTimeInterval {
        return fmod(rawHours(time), 24)
    }
    
    private static func rawDays(time: NSTimeInterval) -> NSTimeInterval {
        return floor(rawHours(time) / 24)
    }
}