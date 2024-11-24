//
//  MealDishesIngridientsListItem.swift
//  Pardus
//
//  Created by Igor Postoev on 3.11.24..
//

import SwiftUI

struct MealDishesIngridientsListItem: Identifiable {
    
    let id: UUID
    let title: String
    let subtitle: String
    let weight: String
    let categoryColor: Color
}
