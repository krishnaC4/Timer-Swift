//
//  StopWatchViewController.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import UIKit

enum TimeState {
    case Default
    case Started
    case Stopped
}

class StopWatchViewController: UIViewController, TimerDelegate {

    // IBOutlet
    
    @IBOutlet weak var mainTimerLabel: UILabel!
    @IBOutlet weak var lapTimerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // Timer
    
    var mainTimer = Timer(timeInterval: 1/60)
    var lapTimer = Timer(timeInterval: 1/60)
    
    // LapManager
    
    let lapManager = LapManager()
    
    // State
    
    var state: TimeState = .Default
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTimerLabel.adjustsFontSizeToFitWidth = true
        tableView.delegate = lapManager
        tableView.dataSource = lapManager
        
        reset()
    }
    
    // MARK: setup
    
    private func setup() {
        setupNavigationItem()
        setupTabBarItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Stopwatch"
    }

    private func setupTabBarItem() {
        let defaultImage = UIImage(named: "stopwatch")!.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage = UIImage(named: "stopwatch_filled")!.imageWithRenderingMode(.AlwaysOriginal)
    
        tabBarItem = UITabBarItem(title: "Stopwatch", image: defaultImage, selectedImage: selectedImage)
    }
    
    // MARK: IBAction
    
    @IBAction func startStopButtonTapped(sender: AnyObject) {
        switch state {
        case .Default:
            start()
        case .Started:
            stop()
        case .Stopped:
            start()
        }
    }
    
    @IBAction func lapButtonTapped(sender: AnyObject) {
        if state == .Stopped {
            reset()
        } else {
            lap()
        }
    }
    
    // MARK: state
    
    private func start() {
        mainTimer.start()
        lapTimer.start()
        
        timerButton.setTitle("Stop", forState: .Normal)
        timerButton.setTitleColor(UIColor.timerStopColor(), forState: .Normal)
        
        lapButton.setTitle("Lap", forState: .Normal)
        
        state = .Started
    }
    
    private func stop() {
        mainTimer.stop()
        lapTimer.stop()
        
        timerButton.setTitle("Start", forState: .Normal)
        lapButton.setTitle("Reset", forState: .Normal)
        
        timerButton.setTitleColor(UIColor.timerStartColor(), forState: .Normal)
        
        state = .Stopped
    }
    
    private func lap() {
        guard state != .Default else { return }
        
        // generate a new lap
        
        let lap = TimedEvent(timeInterval: lapTimer.elapsedTime, name: "Lap \(lapManager.laps.count + 1)")
        lapManager.addLap(lap)
        
        // reset the lap timer
        
        resetLapTimer()
        lapTimer.start()
        
        // reload table
        
        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: lapManager.laps.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    // MARK: reset
    
    private func reset() {
        resetState()
        resetUI()
        resetMainTimer()
        resetLapTimer()
        lapManager.reset()
        tableView.reloadData()
    }
    
    private func resetState() {
        state = .Default
    }
    
    private func resetUI() {
        mainTimerLabel.text = "00:00.00"
        lapTimerLabel.text = "00:00.00"
        
        lapButton.setTitle("Lap", forState: .Normal)
        timerButton.setTitle("Start", forState: .Normal)
    
        timerButton.setTitleColor(UIColor.timerStartColor(), forState: .Normal)
    }
    
    private func resetMainTimer() {
        mainTimer = Timer()
        mainTimer.delegate = self
    }
    
    private func resetLapTimer() {
        lapTimer = Timer()
        lapTimer.delegate = self
    }
    
    // MARK: timer delegate
    
    func timerDidFire(timer: Timer) {
        if timer == mainTimer {
            mainTimerLabel.text = timer.description(.Minutes, milliseconds: true)
        } else {
            lapTimerLabel.text = timer.description(.Minutes, milliseconds: true)
        }
    }
}
