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
    func showDishesPick(mealId: UUID, preselectedDishes: [UUID], completion: @escaping (Set<UUID>) -> Void)
}

// Presenter
protocol MealEditPresenterProtocol: AnyObject, ObservableObject, PresenterProtocol {

    func didAppear()
    func doneTapped()
    func editDishesTapped()
    func remove(dishId: UUID)
}

// Interactor
protocol MealEditInteractorProtocol: InteractorProtocol {
    
    var meal: Meal? { get }
    
    func loadInitialMeal() async throws
    func performWithMeal(action: @escaping (Meal?) -> Void) async throws
    func updateMealDish(dishId: UUID, action: @escaping (MealDish?) -> Void) async throws
    func setSelectedDishes(_ dishesIds: Set<UUID>) async throws
    func remove(dishId: UUID) async throws
    func save() async throws
}

// ViewState
protocol MealEditViewStateProtocol: ViewStateProtocol {
    
    var date: Date { get set }
    var error: String? { get set }
    var dishItems: [MealDishesListItem] { get set }
}
