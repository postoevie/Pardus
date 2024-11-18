//
//  MealDishEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI


// Router
protocol MealDishEditRouterProtocol: RouterProtocol {

    func returnBack()
    func showIngidientsPicklist(dishMealId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void)
}

// Presenter
protocol MealDishEditPresenterProtocol: AnyObject, ObservableObject, PresenterProtocol {

    func didAppear()
    func doneTapped()
    func editIngridientsTapped()
    func remove(ingridientId: UUID)
    func updateIngridientWeight(ingridientId: UUID, weightString: String) 
}

// Interactor
protocol MealDishEditInteractorProtocol: InteractorProtocol {
    
    var mealDishId: UUID? { get  }
    var ingridientsFilter: Predicate? { get }
    
    func loadInitialMealDish() async throws
    func performWithMealDish(action: @escaping (MealDish?) -> Void) async throws
    func performWithIngridient(uid: UUID, action: @escaping (MealIngridient?) -> Void) async throws
    func setSelectedIngridients(_ dishesIds: Set<UUID>) async throws
    func remove(ingridientId: UUID) async throws
    func save() async throws
}

// ViewState
protocol MealDishEditViewStateProtocol: ObservableObject, ViewStateProtocol {
    
    var error: String? { get set }
    var sumKcals: String { get set }
    var sumProteins: String { get set }
    var sumFats: String { get set }
    var sumCarbs: String { get set }
    var navigationTitle: String { get set }
    
    var ingridients: [MealDishesIngridientsListItem] { get set }
}
