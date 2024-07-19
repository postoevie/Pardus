//
//  DishesPicklistState.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import SwiftUI

final class DishesPicklistState: ObservableObject, DishesPicklistStateProtocol {    
    
    @Published var dishes: [DishPickViewModel] = []
    
    @Published var selectedDishes: Set<DishPickViewModel> = Set()
}

struct DishPickViewModel: Identifiable, Hashable, Equatable {
    let id: UUID
    let name: String
    let isMarked: Bool = false
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    init(model: DishModel) {
        self.id = model.id
        self.name = model.name
    }
}

