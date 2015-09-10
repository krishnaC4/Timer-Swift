//
//  TimerViewController.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import AudioToolbox

class TimerViewController: UIViewController, TimerDelegate, PresetTimerDelegate {
    
    @IBOutlet weak private var timerLabel: UILabel!
    @IBOutlet weak private var timerNameLabel: UILabel!
    @IBOutlet weak private var datePicker: UIDatePicker!
    @IBOutlet weak private var stateButton: UIButton!
    @IBOutlet weak private var timerButton: UIButton!
    @IBOutlet weak private var presetsView: UIView!
    
    @IBOutlet weak private var bottomView: UIView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var contentViewHeightConstraint: NSLayoutConstraint!
    
    private var timer: Timer?
    
    private var duration: NSTimeInterval?
    private var state: TimeState = .Default
    
    // MARK: life cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        resetUI()
        embedPresetTimerTableViewController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentViewWidthConstraint.constant = view.frame.size.width * 2.0
        contentViewHeightConstraint.constant = bottomView.frame.size.height
    }
    
    // MARK: setup
    
    private func setup() {
        setupNavigationItem()
        setupTabBarItem()
    }
    
    private func setupNavigationItem() {
       navigationItem.title = "Timer"
    }
    
    private func setupTabBarItem() {
        let defaultImage = UIImage(named: "timer")!.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage = UIImage(named: "timer_filled")!.imageWithRenderingMode(.AlwaysOriginal)
        
        tabBarItem = UITabBarItem(title: "Timer", image: defaultImage, selectedImage: selectedImage)
    }
    
    private func setupUI() {
        timerLabel.adjustsFontSizeToFitWidth = true
        
        datePicker.datePickerMode = .CountDownTimer
        datePicker.countDownDuration = 60
    }
    
    // MARK: IBAction
    
    @IBAction func timerButtonTapped(sender: UIButton) {
        switch state {
        case .Default:
            newTimer(datePicker.countDownDuration)
        case .Stopped:
            cancelTimer()
        case .Started:
            cancelTimer()
        }
    }

    @IBAction func stateButtonTapped(sender: UIButton) {
        switch state {
        case .Stopped:
            startTimer()
        case .Started:
            pauseTimer()
        default:
            return
        }
    }
    
    // MARK: state
    
    private func newTimer(timeInterval: NSTimeInterval) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.timerLabel.alpha = 1.0
            self.datePicker.alpha = 0.0
        }
        duration = timeInterval
        timerLabel.text = TimeFormatter.format(timeInterval, format: .Hours)
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer(timeInterval: 1.0)
        timer?.delegate = self
        timer?.start()
        
        timerButton.setTitle("Cancel", forState: .Normal)
        timerButton.setTitleColor(UIColor.timerStopColor(), forState: .Normal)
        
        stateButton.setTitle("Pause", forState: .Normal)
        stateButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        stateButton.backgroundColor = UIColor.whiteColor()
        
        stateButton.enabled = true
        
        state = .Started
    }
    
    private func pauseTimer() {
        timer?.stop()
        stateButton.setTitle("Resume", forState: .Normal)

        state = .Stopped
    }
    
    private func cancelTimer() {
        reset()
    }
    
    private func timerDone() {
        let action = UIAlertAction(title: "Ok", style: .Cancel) { (action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let alert = UIAlertController(title: "\(timerNameLabel.text) timer done!", message: "", preferredStyle: .Alert)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
        
        reset()
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    // MARK: declarative
    
    private func embedPresetTimerTableViewController() {
        if let viewController = storyboard?.instantiateViewControllerWithIdentifier("PresetTimerTableController") as? PresetTimerSelectionTableViewController {
            viewController.delegate = self
            addChildViewController(viewController)
            presetsView.addSubview(viewController.view)
            viewController.view.frame = presetsView.bounds
            viewController.willMoveToParentViewController(self)
        }
        
    }
    
    // MARK: reset
    
    private func reset() {
        resetState()
        resetTimer()
        resetUI()
        
        // this doesn't belong here
        stateButton.enabled = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.datePicker.alpha = 1.0
            self.timerLabel.alpha = 0.0
            }) { (done: Bool) -> Void in
                self.timerLabel.text = "00:00:00"
        }
    }
    
    private func resetState() {
       state = .Default
    }
    
    private func resetTimer() {
       timer?.stop()
    }
    
    private func resetUI() {
        timerButton.setTitle("Start", forState: .Normal)
        timerButton.setTitleColor(UIColor.timerStartColor(), forState: .Normal)
        stateButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        stateButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        timerNameLabel.text = ""
    }
    
    // MARK: timer delegate
    
    func timerDidFire(_: Timer) {
        duration!--
        timerLabel.text = TimeFormatter.format(duration!, format: .Hours)
        
        if duration == 0 {
            self.timer = nil
            timerDone()
        }
    }
    
    // MARK: preset timer delegate
    
    
    func presetTimerSelectionViewController(viewController: PresetTimerSelectionTableViewController, didSelectPresetTimer timer: TimedEvent) {
        resetTimer()
        newTimer(timer.timeInterval)
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        timerNameLabel.text = timer.name
    }
    
}
