//
//  CountDownEvent.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

protocol CountdownEventDelegate: class {
    func countdownEventDidUpdateTimeLeft(event: CountdownEvent)
}

class CountdownEvent: NSObject, TimerDelegate {
    private(set) var name: String
    private(set) var date: NSDate
    private(set) var image: UIImage
    private(set) var timeLeft: NSTimeInterval?
    
    weak var delegate: CountdownEventDelegate?
    
    lazy private var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(name: String, date: NSDate, image: UIImage) {
        self.name = name
        self.image = image
        self.date = date
        self.timeLeft = date.timeIntervalSinceNow
        
        super.init()
        
        startTimer()
    }
    
    func dateFormatted() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, Y"
        return formatter.stringFromDate(date)
    }
    
    // MARK: timer
    
    private func startTimer() {
        let timer = Timer()
        timer.delegate = self
        timer.start()
    }
    
    // MARK: timer delegate
    
    func timerDidFire(timer: Timer) {
        timeLeft = date.timeIntervalSinceDate(NSDate())
        delegate?.countdownEventDidUpdateTimeLeft(self)
    }
    
    // MARK: helpers
    
    class func defaultEvents() -> Set<CountdownEvent> {
        return [
            halloweenEvent(),
            birthdayEvent(),
            christmasEvent(),
            graduationEvent()
        ]
    }
    
    private class func halloweenEvent() -> CountdownEvent {
        let date = formatter().dateFromString("2015-10-31")
        return CountdownEvent(name: "Halloween", date: date!, image: UIImage(named: "halloween")!)
    }
    
    private class func birthdayEvent() -> CountdownEvent {
        let date = formatter().dateFromString("2015-09-26")
        return CountdownEvent(name: "Mike's Birthday", date: date!, image: UIImage(named: "birthday")!)
    }

    private class func christmasEvent() -> CountdownEvent {
        let date = formatter().dateFromString("2015-12-25")
        return CountdownEvent(name: "Christmas", date: date!, image: UIImage(named: "christmas")!)
    }
    
    private class func graduationEvent() -> CountdownEvent {
        let date = formatter().dateFromString("2015-12-10")
        return CountdownEvent(name: "Graduation", date: date!, image: UIImage(named: "graduation")!)
    }
    
    private class func formatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}