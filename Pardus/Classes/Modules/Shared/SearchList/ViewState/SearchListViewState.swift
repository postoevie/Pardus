//
//  DishesListViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI
import Combine

final class SearchListViewState: ObservableObject, SearchListViewStateProtocol {
   
    private let id = UUID()
    private var presenter: (any SearchListPresenterProtocol)?
    
    @Published var searchText: String = ""
    @Published var navigationTitle: String = ""
    @Published var items: [SearchListItem] = []
    
    var subscription: AnyCancellable? = nil
    
    func set(with presener: any SearchListPresenterProtocol) {
        self.presenter = presener
        subscription = $searchText.sink {
            presener.setSearchText($0)
        }
    }
    
    func set(items: [SearchListItem]) {
        self.items = items
    }
    
    func setNavigationtitle(text: String) {
        navigationTitle = text
    }
}
