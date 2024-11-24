//
//  IngridientCategory+Picklist.swift
//  Pardus
//
//  Created by Igor Postoev on 6.11.24..
//

extension IngridientCategory: PicklistItemEntityType {
    
    var picklistItemTitle: String {
        name
    }
    
    var badgeColorHex: String? {
        colorHex
    }
}
