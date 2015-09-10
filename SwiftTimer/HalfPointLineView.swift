//
//  HalfPointLineView.swift
//  SwiftTimer
//
//  Created by Michael Kavouras on 8/27/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class HalfPointLineView: UIView {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heightConstraint.constant = 0.5
    }

}
