//
//  MealEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI


// Router
protocol MealEditRouterProtocol: RouterProtocol {

    func returnBack()
    func showDishesPick(preselectedDishes: [UUID], completion: @escaping ([UUID]) -> Void)
}

// Presenter
protocol MealEditPresenterProtocol: AnyObject, ObservableObject, PresenterProtocol {

    func didAppear()
    func doneTapped()
}

// Interactor
protocol MealEditInteractorProtocol: InteractorProtocol {
    
    var meal: MealModel? { get async }
    
    func loadInitialMeal() async throws
    func update(model: MealModel) async throws
    func setSelectedDishes(_ dishesIds: [UUID]) async throws
    func save() async throws
}

// ViewState
protocol MealEditViewStateProtocol: ViewStateProtocol {
    
    var date: Date { get set }
    var error: String? { get set }
    var dishes: [String] { get set }
}
