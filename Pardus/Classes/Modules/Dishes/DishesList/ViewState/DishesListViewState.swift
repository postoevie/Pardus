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
    @Published var items: [DishesListItem] = []
    
    var subscription: AnyCancellable? = nil
    
    func set(with presener: DishesListPresenterProtocol) {
        self.presenter = presener
        subscription = $searchText.sink {
            presener.setSearchText($0)
        }
    }
    
    func set(items: [DishesListItem]) {
        self.items = items
    }
}
