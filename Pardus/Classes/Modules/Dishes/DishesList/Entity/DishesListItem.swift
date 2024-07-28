//
//  DishesListItem.swift
//  Pardus
//
//  Created by Igor Postoev on 28.7.24..
//

import SwiftUI

struct DishesListItem: Identifiable {
    let id: UUID
    let name: String
    let categoryColor: UIColor?
    
    init(id: UUID, name: String, categoryColor: UIColor?) {
        self.id = id
        self.name = name
        self.categoryColor = categoryColor
    }
    
    init(model: DishModel) {
        self.id = model.id
        self.name = model.name
        self.categoryColor = if let category = model.category {
            try? .init(hex: category.colorHex)
        } else {
            nil
        }
    }
}

