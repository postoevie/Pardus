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
    let dishes: [DishesListItem]
}

final class DishesSectionsListViewState: ObservableObject, DishesSectionsListViewStateProtocol {
    
    @Published var sections: [DishListSection] = []
    @Published var alertTitle: String = ""
    @Published var alertPresented: Bool = false
    
    func set(sections: [DishListSection]) {
        self.sections = sections
    }
    
    func showAlert(title: String) {
        self.alertTitle = title
        self.alertPresented = true
    }
    
    func hideAlert() {
        self.alertTitle = ""
        self.alertPresented = false
    }
}

