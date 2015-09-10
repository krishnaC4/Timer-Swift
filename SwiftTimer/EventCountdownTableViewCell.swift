//
//  EventCountdownTableViewCell.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class EventCountdownTableViewCell: UITableViewCell, CountdownEventDelegate {

    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var countdownTextLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var event: CountdownEvent? {
        didSet {
            event!.delegate = self
            nameTextLabel.text = event!.name
            dateTextLabel.text = event!.dateFormatted()
            backgroundImageView.image = event!.image
            if let time = event!.timeLeft {
                countdownTextLabel.text = TimeFormatter.format(time, format: .Days)
            }
        }
    }
    
    func countdownEventDidUpdateTimeLeft(event: CountdownEvent) {
        countdownTextLabel.text = TimeFormatter.format(event.timeLeft!, format: .Days)
    }

}
