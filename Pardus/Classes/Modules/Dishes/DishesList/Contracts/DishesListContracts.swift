//
//  DishesListContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI


// Router
protocol DishesListRouterProtocol: RouterProtocol {

    func showAddDish()
    func showEditDish(dishId: UUID)
    func showSections()
}

// Presenter
protocol DishesListPresenterProtocol: PresenterProtocol {

    func tapNewDish()
    func didAppear()
    func delete(dishId: UUID)
    func tapEditDish(dishId: UUID)
    func setSearchText(_ text: String)
}

// Interactor
protocol DishesListInteractorProtocol: InteractorProtocol {

    var filteredDishes: [DishModel] { get }
    func loadDishes() async throws
    func deleteDish(dishId: UUID) async throws
    func setFilterText(_ text: String)
}

// ViewState
protocol DishesListViewStateProtocol: ViewStateProtocol {
    
    func set(items: [DishesListItem])
}
