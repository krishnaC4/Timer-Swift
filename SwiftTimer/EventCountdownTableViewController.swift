//
//  EventCountdownTableViewController.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import UIKit

enum CountdownState {
    case EventName
    case CountdownTimer
}

class EventCountdownTableViewController: UITableViewController {
    
    let events: Set<CountdownEvent> = CountdownEvent.defaultEvents()
    var state: CountdownState = .EventName
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupTabBarItem()
        setupNavigationItem()
    }
    
    private func setupTabBarItem() {
      navigationItem.title = "Events Countdown"
    }
    
    private func setupNavigationItem() {
        let defaultImage = UIImage(named: "event")!.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage = UIImage(named: "event_filled")!.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem = UITabBarItem(title:"Events", image:defaultImage, selectedImage:selectedImage)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCellIdentifier", forIndexPath: indexPath) as! EventCountdownTableViewCell
        
        let event = Array(events)[indexPath.row]
        cell.event = event;
        cell.countdownTextLabel.hidden = state == .EventName
        cell.nameTextLabel.hidden = state == .CountdownTimer
        cell.dateTextLabel.hidden = state == .CountdownTimer

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        state = state == .EventName ? .CountdownTimer : .EventName
        tableView.reloadData()
    }
}
