//
//  MealEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI
import Combine

final class MealEditPresenter: MealEditPresenterProtocol {
  
    private let router: MealEditRouterProtocol
    private weak var viewState: MealEditViewState?
    private let interactor: MealEditInteractorProtocol
    
    var subscriptions = [AnyCancellable]()
    
    init(router: MealEditRouterProtocol,
         interactor: MealEditInteractorProtocol,
         viewState: MealEditViewState) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func didAppear() {
        Task {
            try await interactor.loadInitialMeal()
            try await interactor.performWithMeal { meal in
                self.updateViewState(meal: meal)
            }
        }
    }
    
    func tapEditDish(dishId: UUID) {
        Task {
            try await valueSubmitted()
            try await interactor.save()
            await MainActor.run {
                router.showEditDish(dishId: dishId)
            }
        }
    }
    
    func editDishesTapped() {
        guard let mealId = self.interactor.mealId else {
            return
        }
        Task {
            try await valueSubmitted()
            let filter = self.interactor.dishesFilter
            await MainActor.run {
                self.router.showDishesPick(mealId: mealId, filter: filter) { selectedDishIds in
                    self.router.returnBack()
                    Task {
                        try await self.interactor.setSelectedDishes(selectedDishIds)
                        try await self.interactor.performWithMeal { meal in
                            self.updateViewState(meal: meal)
                        }
                    }
                }
            }
        }
    }
    
    func remove(dishId: UUID) {
        Task {
            try await interactor.remove(dishId: dishId)
            try await interactor.performWithMeal { meal in
                self.updateViewState(meal: meal)
            }
        }
    }
    
    func doneTapped() {
        Task {
            try await valueSubmitted()
            try await interactor.save()
            await MainActor.run {
                router.returnBack()
            }
        }
    }
    
    private func valueSubmitted() async throws {
        guard let viewState else {
            assertionFailure("Prerequsites not accomplished")
            return
        }
        try await interactor.performWithMeal { meal in
            meal?.date = viewState.date
        }
    }
    
    private func updateViewState(meal: Meal?) {
        guard let viewState = self.viewState else {
            return
        }
        guard let meal else {
            DispatchQueue.main.async {
                viewState.error = "No entity"
            }
            return
        }
        let mealDate = meal.date
        let dishItems = meal.dishes.map(self.mapToListItem)
        let weight = meal.weight
        let sumProteins = String(meal.proteins)
        let sumFats = String(meal.fats)
        let sumCarbs = String(meal.carbs)
        let sumKcals = String(meal.calories)
        
        DispatchQueue.main.async {
            viewState.error = nil
            viewState.date = mealDate
            viewState.dishItems = dishItems
            viewState.weight = String(weight)
            viewState.sumProteins = String(sumProteins)
            viewState.sumFats = String(sumFats)
            viewState.sumCarbs = String(sumCarbs)
            viewState.sumKcals = String(sumKcals)
        }
    }
    
    private func mapToListItem(_ mealDish: MealDish) -> MealDishesListItem {
        let dish = mealDish.dish
        let formatter = Formatter.nutrients
        let weightString = formatter.string(for: mealDish.weight) ?? "0"
        let calString = formatter.string(for: mealDish.calories) ?? "0"
        let proteinsString = formatter.string(for: mealDish.proteins) ?? "0"
        let fatsString = formatter.string(for: mealDish.fats) ?? "0"
        let carbsString = formatter.string(for: mealDish.carbs) ?? "0"
        var categoryColor: UIColor?
        if let colorHex = dish.category?.colorHex {
            categoryColor = try? .init(hex: colorHex)
        }
        let item = MealDishesListItem(id: mealDish.id,
                                      title: dish.name,
                                      subtitle: "вес: \(weightString) kcal: \(calString) б: \(proteinsString) ж: \(fatsString) у: \(carbsString)",
                                      weight: NumberFormatter.nutrients.string(for: mealDish.weight) ?? "0",
                                      categoryColor: categoryColor)
        return item
    }
}
