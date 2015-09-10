//
//  PresetTimerSelectionTableViewController.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol PresetTimerDelegate: class {
    func presetTimerSelectionViewController(viewController: PresetTimerSelectionTableViewController, didSelectPresetTimer timer: TimedEvent)
}

class PresetTimerSelectionTableViewController: UITableViewController, NewPresetTimerDelegate {
    
    private(set) var timers: [TimedEvent] = TimedEvent.defaultPresetTimers()
    weak var delegate: PresetTimerDelegate?
    
    private func addTimer(timer: TimedEvent) {
        timers.insert(timer, atIndex: 0)
    }

    // MARK: - table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count + 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 44.0 : 60.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewPresetTimerCellIdentifier", forIndexPath: indexPath) as! PresetTimerTableViewCell
            cell.nameTextLabel.textColor = UIColor.timerStartColor()
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
            return cell
        } else {
            let timer = timers[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("PresetTimerCellIdentifier", forIndexPath: indexPath) as! PresetTimerTableViewCell
            cell.nameTextLabel.text = timer.name
            cell.timeTextLabel.text = timer.description(.Hours)
            return cell
        }
    }
    
    // MARK: - table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row != 0 else { return }
        
        let timer = timers[indexPath.row - 1]
        delegate?.presetTimerSelectionViewController(self, didSelectPresetTimer: timer)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if let viewController = storyboard?.instantiateViewControllerWithIdentifier("PresetTimerController") as? NewPresetTimerTableViewController {
            viewController.delegate = self
            viewController.timer = timers[indexPath.row - 1]
            let navController = UINavigationController(rootViewController: viewController)
            presentViewController(navController, animated: true, completion: nil)
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.setSelected(false, animated: true)
        }
    }
    
    // MARK: - navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let viewController = navigationController.viewControllers[0] as! NewPresetTimerTableViewController
        viewController.delegate = self
    }
    
    // MARK: new preset timer delegate
    
    func presetTimerViewController(viewController: NewPresetTimerTableViewController, didCreateNewTimer timer: TimedEvent) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.addTimer(timer)
            let indexPaths = [NSIndexPath(forRow: 1, inSection: 0)]
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
        }
    }
    
    func presetTimerViewController(viewController: NewPresetTimerTableViewController, didUpdateTimer timer: TimedEvent) {
        self.tableView.reloadData()
    }
    
    func presetTimerViewController(viewController: NewPresetTimerTableViewController, didDeleteTimer timer: TimedEvent) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            if let idx = self.timers.indexOf(timer) {
                self.timers.removeAtIndex(idx)
                let indexPaths = [NSIndexPath(forRow: idx+1, inSection: 0)]
                self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
            }
        }
    }

}
