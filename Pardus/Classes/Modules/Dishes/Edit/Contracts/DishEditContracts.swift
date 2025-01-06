//
//  DishEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

// Router
protocol DishEditRouterProtocol: RouterProtocol {

    func returnBack()
    func showIngridientsPicklist(dishId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void)
    func showCategoriesPicklist(dishId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void)
    func hidePicklist()
}

// Presenter
protocol DishEditPresenterProtocol: ObservableObject, PresenterProtocol {

    func didAppear()
    func doneTapped()
    func editCategoryTapped()
    func editIngridientsTapped()
    func remove(ingridientId: UUID)
}

// Interactor
protocol DishEditInteractorProtocol: InteractorProtocol {

    var dishId: UUID? { get }
    var categoriesFilter: Predicate? { get }
    var ingridientsFilter: Predicate? { get }
    
    func loadInitialDish() async throws
    func performWithDish(action: @escaping (Dish?) -> Void) async throws
    func performWithIngridients(action: @escaping ([Ingridient]) -> Void) async
    func setCategory(uid: UUID?) async throws
    func setSelectedIngridients(uids: Set<UUID>) async throws
    func remove(ingridientId: UUID) async throws
    func save() async throws
}

// ViewState
protocol DishEditViewStateProtocol: ObservableObject, ViewStateProtocol {
    
    var name: String { get set }
    var category: DishCategoryViewModel? { get set }
    var ingridients: [DishIngridientsListItem] { get set }
    var error: String? { get set }
}
