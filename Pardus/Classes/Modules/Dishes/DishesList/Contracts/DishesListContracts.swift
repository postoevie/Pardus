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

    func showAdd()
    func showEdit(dishId: UUID)
}

// Presenter
protocol DishesListPresenterProtocol: PresenterProtocol {

    func tapAddNew()
    func didAppear()
    func delete(indexSet: IndexSet)
    func tapDish(_ dish: DishViewModel)
}

// Interactor
protocol DishesListInteractorProtocol: InteractorProtocol {

    var dishModels: [DishViewModel] { get }
    func loadDishes() async throws
    func deleteDishes(indexSet: IndexSet) async throws
    func stashState()
}

// ViewState
protocol DishesListViewStateProtocol: ViewStateProtocol {
    func set(with presenter: DishesListPresenterProtocol)
    func set(items: [DishViewModel])
}
