//
//  DishesSectionsListViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//

import SwiftUI


struct DishCategoryViewModel: Hashable {
    
    let id: UUID
    let name: String
    let color: UIColor?
}

struct DishListSection {
    
    let category: DishCategoryViewModel
    let dishes: [DishViewModel]
}

final class DishesSectionsListViewState: ObservableObject, DishesSectionsListViewStateProtocol {
    
    @Published var sections: [DishListSection] = []
    
    func set(sections: [DishListSection]) {
        self.sections = sections
    }
}

