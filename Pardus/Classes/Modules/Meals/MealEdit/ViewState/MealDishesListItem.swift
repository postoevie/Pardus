//
//  MealDishesListItem.swift
//  Pardus
//
//  Created by Igor Postoev on 16.10.24..
//

import SwiftUI

class MealDishesListItem: Identifiable {
    
    let id: UUID
    let title: String
    let subtitle: String
    let categoryColor: UIColor?
    var weight: String
    
    init(id: UUID, name: String, subtitle: String, weight: String, categoryColor: UIColor?) {
        self.id = id
        self.title = name
        self.subtitle = subtitle
        self.categoryColor = categoryColor
        self.weight = weight
    }
}
