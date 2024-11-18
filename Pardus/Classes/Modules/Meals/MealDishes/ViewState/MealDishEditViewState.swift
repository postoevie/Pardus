//
//  MealEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

final class MealDishEditViewState: ObservableObject, MealDishEditViewStateProtocol {
    
    @Published var error: String?
    @Published var ingridients: [MealDishesIngridientsListItem] = []
    @Published var sumKcals: String = ""
    @Published var sumProteins: String = ""
    @Published var sumFats: String = ""
    @Published var sumCarbs: String = ""
    @Published var navigationTitle: String = ""

    func set(ingridients: [MealDishesIngridientsListItem]) {
        self.ingridients = ingridients
    }
}
