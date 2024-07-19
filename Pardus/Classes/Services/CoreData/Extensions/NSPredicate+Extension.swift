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
}
