//
//  MealsListContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI


// Router
protocol MealsListRouterProtocol: RouterProtocol {
    
    func showAdd()
    func showEdit(mealId: UUID)
}

// Presenter
protocol MealsListPresenterProtocol: PresenterProtocol {
    
    func tapAddNewMeal()
    func didAppear()
    func deleteMeals(indexSet: IndexSet)
    func tapMeal(_ meal: MealModel)
}

// Interactor
protocol MealsListInteractorProtocol: InteractorProtocol {
    var mealModels: [MealModel] { get }
    func loadMeals() async throws
    func deleteMeals(indexSet: IndexSet) async throws
    func stashState()
}

// ViewState
protocol MealsListViewStateProtocol: ViewStateProtocol {
    func set(presenter: MealsListPresenterProtocol)
    func set(items: [MealModel])
}
