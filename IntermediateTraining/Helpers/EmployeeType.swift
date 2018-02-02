//
//  EmployeeType.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 27/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import Foundation

enum EmployeeType: String {
    case Executive
    case SeniorManagement = "Senior Management"
    case TeamLeader = "Team Leader"
    case Staff
    
    static func from(hashValue: Int) -> EmployeeType {
        switch hashValue {
        case 0:
            return .Executive
        case 1:
            return .SeniorManagement
        case 2:
            return .TeamLeader
        default:
            return .Staff
        }
    }
}
