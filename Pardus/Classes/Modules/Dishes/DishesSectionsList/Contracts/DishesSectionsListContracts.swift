//
//  DishesSectionsListContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//  
//

import SwiftUI


// Router
protocol DishesSectionsListRouterProtocol: RouterProtocol {

    func showAddDish()
    func showAddCategory()
    func showEditCategory(dishCategoryId: UUID)
    func showEditDish(dishId: UUID)
    func showSearchList()
}

// Presenter
protocol DishesSectionsListPresenterProtocol: PresenterProtocol {

    func tapNewDish()
    func tapNewCategory()
    func didAppear()
    func delete(categoryId: UUID)
    func tapEdit(categoryId: UUID)
    func delete(dishId: UUID)
    func tapEditDish(dishId: UUID)
}

// Interactor
protocol DishesSectionsListInteractorProtocol: InteractorProtocol {

    var dishCategories: [DishCategoryModel] { get }
    var dishes: [DishModel] { get }
    func loadDishes() async throws
    func deleteDish(dishId: UUID) async throws
    func deleteDishCategory(categoryId: UUID) async throws
}

// ViewState
protocol DishesSectionsListViewStateProtocol: ViewStateProtocol {
    
    func set(sections: [DishListSection])
    func showAlert(title: String)
    func hideAlert()
}
