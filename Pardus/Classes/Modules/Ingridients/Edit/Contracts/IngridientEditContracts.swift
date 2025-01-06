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
    func hidePicklist()
    func showPicklist(ingridientId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void)
}

// Presenter
protocol IngridientEditPresenterProtocol: ObservableObject, PresenterProtocol {

    func didAppear()
    func tapEditCategory()
    func doneTapped()
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
protocol IngridientEditViewStateProtocol: ObservableObject, ViewStateProtocol {
    var name: String { get set }
    var calories: String { get set }
    var proteins: String { get set }
    var fats: String { get set }
    var carbohydrates: String { get set }
    var category: IngridientCategoryViewModel? { get set }
    var error: String? { get set }
}
