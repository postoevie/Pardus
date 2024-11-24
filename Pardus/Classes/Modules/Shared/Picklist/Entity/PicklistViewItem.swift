//
//  PicklistViewItem.swift
//  Pardus
//
//  Created by Igor Postoev on 28.7.24..
//

import SwiftUI

struct PicklistViewItem: Hashable {
    
    let id: UUID
    let isSelected: Bool
    let type: PicklistViewItemType
}

enum PicklistViewItemType: Hashable {
    
    case onlyTitle(title: String, badgeColor: Color)
    case withSubtitle(title: String, subtitle: String, badgeColor: Color)
}

