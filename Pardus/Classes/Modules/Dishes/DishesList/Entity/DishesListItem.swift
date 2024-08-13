//
//  DishesListItem.swift
//  Pardus
//
//  Created by Igor Postoev on 28.7.24..
//

import SwiftUI

struct DishesListItem: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let categoryColor: UIColor?
    
    init(id: UUID, name: String, subtitle: String, categoryColor: UIColor?) {
        self.id = id
        self.title = name
        self.subtitle = subtitle
        self.categoryColor = categoryColor
    }
    
    init(model: DishModel) {
        self.id = model.id
        self.title = model.name
        let formatter = Formatter.dishNumbers
        let calString = formatter.string(for: model.calories) ?? "0"
        let proteinsString = formatter.string(for: model.proteins) ?? "0"
        let fatsString = formatter.string(for: model.fats) ?? "0"
        let carbohydratesString = formatter.string(for: model.carbohydrates) ?? "0"
        self.subtitle = "\(calString) kcal \(proteinsString)/\(fatsString)/\(carbohydratesString)"
        self.categoryColor = if let category = model.category {
            try? .init(hex: category.colorHex)
        } else {
            nil
        }
    }
}

