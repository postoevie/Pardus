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
    @Published var kcalsPer100: String = ""
    @Published var dishDescription: String = ""
    @Published var error: String?
}
