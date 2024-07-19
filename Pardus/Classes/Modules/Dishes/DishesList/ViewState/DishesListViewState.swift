//
//  DishesListViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

final class DishesListViewState: ObservableObject, DishesListViewStateProtocol {    
    private let id = UUID()
    private var presenter: DishesListPresenterProtocol?
    
    @Published var dishesList: [DishViewModel] = []
    
    func set(with presener: DishesListPresenterProtocol) {
        self.presenter = presener
    }
    
    func set(items: [DishViewModel]) {
        dishesList = items
    }
}

struct DishViewModel: Identifiable {
    let id: UUID
    let name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    init(model: DishModel) {
        self.id = model.id
        self.name = model.name
    }
}
