//
//  DishEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

struct IngridientCategoryViewModel {
    
    let id: UUID
    let name: String
    let color: Color
}

final class IngridientEditViewState: ObservableObject, IngridientEditViewStateProtocol {
    
    @Published var name: String = ""
    @Published var category: IngridientCategoryViewModel?
    @Published var calories: String = ""
    @Published var proteins: String = ""
    @Published var fats: String = ""
    @Published var carbohydrates: String = ""
    @Published var error: String?
}
