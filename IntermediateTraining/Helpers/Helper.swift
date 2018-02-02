//
//  Helper.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 20/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    private init() {}
    
    static func showOkAlert(title: String, message: String, controller: UIViewController) {
        let alert = UIAlertController(title: "Bad Date", message: "Birthday date entered not valid", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}

