//
//  protocols.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 21/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import Foundation
import CoreData

protocol EntityDelegate: AnyObject {
    func didAdd(entity: NSManagedObject)
    func didEdit(entity: NSManagedObject)
}
