//
//  Formatter+DishFormat.swift
//  Pardus
//
//  Created by Igor Postoev on 13.8.24..
//

import Foundation

extension Formatter {
    
    // Opt for singleton instead of DI and service because here will be no business logic.
    static let dishNumbers: Formatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()
}
