//
//  DishesListViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI
import Combine


final class DishesListViewState: ObservableObject, DishesListViewStateProtocol {
   
    private let id = UUID()
    private var presenter: DishesListPresenterProtocol?
    
    @Published var searchText: String = ""
    @Published var dishesList: [DishViewModel] = []
    @Published var sections: [DishListSection] = []
    
    var subscription: AnyCancellable? = nil
    
    func set(with presener: DishesListPresenterProtocol) {
        self.presenter = presener
        subscription = $searchText.sink {
            presener.setSearchText($0)
        }
    }
    
    func set(dishesList: [DishViewModel]) {
        self.dishesList = dishesList
    }
    
    func set(sections: [DishListSection]) {
        self.sections = sections
    }
}

struct DishViewModel: Identifiable {
    let id: UUID
    let name: String
    let categoryColor: UIColor?
    
    init(id: UUID, name: String, categoryColor: UIColor?) {
        self.id = id
        self.name = name
        self.categoryColor = categoryColor
    }
    
    init(model: DishModel) {
        self.id = model.id
        self.name = model.name
        self.categoryColor = if let category = model.category {
            try? .init(hex: category.colorHex)
        } else {
            nil
        }
    }
}
