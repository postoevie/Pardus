//
//  MealsListPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

final class MealsListPresenter: ObservableObject, MealsListPresenterProtocol {
    
    private let router: MealsListRouterProtocol
    private weak var viewState: MealsListViewStateProtocol?
    private let interactor: MealsListInteractorProtocol
    
    init(router: MealsListRouterProtocol,
         interactor: MealsListInteractorProtocol,
         viewState: MealsListViewStateProtocol) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func tapAddNewMeal() {
        interactor.stashState()
        router.showAdd()
    }
    
    func deleteMeals(indexSet: IndexSet) {
        Task {
            try await interactor.deleteMeals(indexSet: indexSet)
            try await interactor.loadMeals()
            await MainActor.run {
                viewState?.set(items: interactor.mealModels)
            }
        }
    }
    
    func tapMeal(_ meal: MealModel) {
        router.showEdit(mealId: meal.id)
    }
    
    func didAppear() {
        Task {
            try await interactor.loadMeals()
            await MainActor.run {
                viewState?.set(items: interactor.mealModels)
            }
        }
    }
}
