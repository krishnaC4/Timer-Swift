//
//  RoundableButton.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/28/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import UIKit

@IBDesignable
class RoundableButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

}
