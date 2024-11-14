//
//  Ingridient+Picklist.swift
//  Pardus
//
//  Created by Igor Postoev on 2.11.24..
//

extension Ingridient: PicklistItemEntityType {
    
    var picklistItemTitle: String {
        name
    }
    
    var indicatorColorHex: String? {
        category?.colorHex
    }
}
