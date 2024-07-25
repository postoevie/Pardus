//
//  DishesSectionsListViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//

import SwiftUI

struct DishListSection {
    
    let categoryId: UUID?
    let title: String
    let color: UIColor?
    let dishes: [DishViewModel]
}

final class DishesSectionsListViewState: ObservableObject, DishesSectionsListViewStateProtocol {
    
    @Published var sections: [DishListSection] = []
    
    func set(sections: [DishListSection]) {
        self.sections = sections
    }
}

