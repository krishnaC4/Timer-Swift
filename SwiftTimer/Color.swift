//
//  Color.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/28/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // green
    class func timerStartColor() -> UIColor {
        return UIColor(red: 125/255.0, green: 205/255.0, blue: 140/255.0, alpha: 1.0)
    }
    
    // red
    class func timerStopColor() -> UIColor {
        return UIColor(red: 249/255.0, green: 91/255.0, blue: 91/255.0, alpha: 1.0)
    }
}
