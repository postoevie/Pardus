//
//  CategoriesListItem.swift
//  Pardus
//
//  Created by Igor Postoev on 28.7.24..
//

import SwiftUI

struct CategoriesListItem: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let categoryColor: UIColor
    
    init(id: UUID, title: String, subtitle: String, categoryColor: UIColor) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.categoryColor = categoryColor
    }
}

