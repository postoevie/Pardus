//
//  DishEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

struct DishCategoryViewModel {
    
    let id: UUID
    let name: String
    let color: UIColor?
}

final class DishEditViewState: ObservableObject, DishEditViewStateProtocol {
    
    @Published var name: String = ""
    @Published var category: DishCategoryViewModel?
    @Published var calories: Double = 0
    @Published var proteins: Double = 0
    @Published var fats: Double = 0
    @Published var carbohydrates: Double = 0
    @Published var error: String?
}
