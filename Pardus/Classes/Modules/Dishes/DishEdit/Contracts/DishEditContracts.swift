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

    var data: DishEditData? { get }
    var dishCategory: DishCategoryViewModel? { get }
    
    func loadDish() async throws
    func updateDishWith(categoryId: UUID?) async throws
    func update(data: DishEditData) async throws
    func save() async throws
}

// ViewState
protocol DishEditViewStateProtocol: ViewStateProtocol {
    var name: String { get set }
    var calories: Double { get set }
    var proteins: Double { get set }
    var fats: Double { get set }
    var carbohydrates: Double { get set }
    var category: DishCategoryViewModel? { get set }
    var error: String? { get set }
}
