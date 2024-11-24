//
//  Dish+Picklist.swift
//  Pardus
//
//  Created by Igor Postoev on 2.11.24..
//

extension Dish: PicklistItemEntityType {
    
    var picklistItemTitle: String {
        name
    }
    
    var badgeColorHex: String? {
        category?.colorHex
    }
}
