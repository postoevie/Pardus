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
    func hideLast()
    func showPicklist(preselectedCategories: Set<UUID>, completion: @escaping (Set<UUID>) -> Void)
}

// Presenter
protocol DishEditPresenterProtocol: PresenterProtocol {

    func didAppear()
    func doneTapped()
    func navigateBackTapped()
}

// Interactor
protocol DishEditInteractorProtocol: InteractorProtocol {

    var dish: DishModel? { get }
    
    func loadDish() async throws
    func updateDishWith(categoryId: UUID?) async throws
    func update(model: DishModel) async throws
    func save() async throws
}

// ViewState
protocol DishEditViewStateProtocol: ViewStateProtocol {
    var name: String { get set }
    var error: String? { get set }
    var kcalsPer100: String { get set }
    var dishDescription: String { get set }
    var category: DishCategoryViewModel? { get set }
}
