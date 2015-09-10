//
//  LapManager.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

class LapManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private(set) var laps: [TimedEvent] = [TimedEvent]()
    private let LapCellIdentifier = "LapCellIdentifier"
    
    func addLap(lap: TimedEvent) {
        laps.append(lap)
    }
    
    func reset() {
        laps = []
    }
    
    // MARK: table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LapCellIdentifier, forIndexPath: indexPath)
        
        let lap = laps[indexPath.row]
        cell.textLabel!.text = "Lap \(indexPath.row + 1)"
        cell.detailTextLabel!.text = lap.description(.Minutes, milliseconds: true)
        
        return cell
    
    }
}
