//
//  NewPresetTimerTableViewController.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/28/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol NewPresetTimerDelegate: class {
    func presetTimerViewController(viewController: NewPresetTimerTableViewController, didCreateNewTimer timer: TimedEvent)
    func presetTimerViewController(viewController: NewPresetTimerTableViewController, didUpdateTimer timer: TimedEvent)
    func presetTimerViewController(viewController: NewPresetTimerTableViewController, didDeleteTimer timer: TimedEvent)
}

class NewPresetTimerTableViewController: UITableViewController {
    
    weak var delegate: NewPresetTimerDelegate?
    var timer: TimedEvent?

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .CountDownTimer
        datePicker.countDownDuration = 60
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 5, 20))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .Always
        nameTextField.tintColor = UIColor.timerStopColor()
        
        deleteButton.setTitleColor(UIColor.timerStopColor(), forState: .Normal)
        
        if let timer = timer {
            nameTextField.text = timer.name
            datePicker.countDownDuration = timer.timeInterval
            navigationItem.title = timer.name
        } else {
            deleteButton.hidden = true
            navigationItem.title = "New Timer"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField.resignFirstResponder()
    }

    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        if let text = nameTextField.text {
            if var timer = timer {
                timer.name = text
                timer.timeInterval = datePicker.countDownDuration
                delegate?.presetTimerViewController(self, didUpdateTimer: timer)
            } else {
                let timer = TimedEvent(timeInterval: datePicker.countDownDuration, name: text)
                delegate?.presetTimerViewController(self, didCreateNewTimer: timer)
            }
        } else {
            let alert = UIAlertController(title: "Womp womp", message: "Your timer needs a name!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(sender: UIButton) {
        if let timer = timer {
            delegate?.presetTimerViewController(self, didDeleteTimer: timer)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
       dismissViewControllerAnimated(true, completion: nil)
    }

}
