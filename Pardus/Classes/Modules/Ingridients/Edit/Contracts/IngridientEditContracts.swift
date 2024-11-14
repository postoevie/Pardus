//
//  IngridientEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI


// Router
protocol IngridientEditRouterProtocol: RouterProtocol {

    func returnBack()
    func hideLast()
    func showPicklist(ingridientId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void)
}

// Presenter
protocol IngridientEditPresenterProtocol: PresenterProtocol {

    func didAppear()
    func doneTapped()
    func navigateBackTapped()
}

// Interactor
protocol IngridientEditInteractorProtocol: InteractorProtocol {

    var ingridientId: UUID? { get }
    var categoryFilter: Predicate? { get }
    var data: IngridientEditData? { get }
    var ingridientCategory: IngridientCategoryViewModel? { get }
    
    func loadIngridient() async throws
    func updateIngridientWith(categoryId: UUID?) async throws
    func update(data: IngridientEditData) async throws
    func save() async throws
}

// ViewState
protocol IngridientEditViewStateProtocol: ViewStateProtocol {
    var name: String { get set }
    var calories: Double { get set }
    var proteins: Double { get set }
    var fats: Double { get set }
    var carbohydrates: Double { get set }
    var category: IngridientCategoryViewModel? { get set }
    var error: String? { get set }
}
