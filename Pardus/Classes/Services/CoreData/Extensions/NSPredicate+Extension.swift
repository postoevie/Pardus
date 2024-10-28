//
//  NSPredicate+Extension.swift
//  Pardus
//
//  Created by Igor Postoev on 23.5.24..
//

import Foundation

extension NSPredicate {
    
    static func idIn(uids: [UUID]) -> NSPredicate {
        NSPredicate(format: "id in %@", uids)
    }
    
    static func valIn(fieldName: String, argument: CVarArg) -> NSPredicate {
        NSPredicate(format: "\(fieldName) in %@", argument)
    }
    
    static func equal(fieldName: String, argument: CVarArg) -> NSPredicate {
        NSPredicate(format: "id == %@", argument)
    }
}
