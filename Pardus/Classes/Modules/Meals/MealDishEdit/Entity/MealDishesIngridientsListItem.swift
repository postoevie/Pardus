//
//  MealDishesIngridientsListItem.swift
//  Pardus
//
//  Created by Igor Postoev on 3.11.24..
//

import SwiftUI

struct MealDishesIngridientsListItem: Identifiable {
    
    let id: UUID
    var title: String
    var subtitle: String
    var weight: String
    var categoryColor: Color
    
    init(id: UUID, title: String, subtitle: String, weight: String, categoryColor: Color) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.weight = weight
        self.categoryColor = categoryColor
    }
}
