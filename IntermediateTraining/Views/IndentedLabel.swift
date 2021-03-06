//
//  IndentedLabel.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 27/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import UIKit

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}
