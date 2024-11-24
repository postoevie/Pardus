//
//  DishCategory.swift
//  Pardus
//
//  Created by Igor Postoev on 2.11.24..
//

extension DishCategory: PicklistItemEntityType {
    
    var badgeColorHex: String? {
        colorHex
    }
    
    var picklistItemTitle: String {
        name
    }
}
