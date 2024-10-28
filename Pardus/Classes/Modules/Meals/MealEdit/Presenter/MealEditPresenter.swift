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
    
    func updateDishMealWeight(mealDishId: UUID, weightString: String) {
        Task {
            let weight: NSNumber = NumberFormatter.dishNumbers.number(from: weightString) ?? .init(value: 0)
            try await interactor.performWithMeal { meal in
                let mealDish = meal?.dishes[mealDishId]
                mealDish?.weight = weight.doubleValue
                self.updateViewState(meal: meal)
            }
        }
    }
    
    func editDishesTapped() {
        Task {
            try await valueSubmitted()
            try await interactor.performWithMeal { meal in
                guard let meal else {
                    assertionFailure("Editing is enabled with no meal")
                    self.updateViewState(meal: nil)
                    return
                }
                let preselectedDishIds = meal.dishes.map { $0.dish.id }
                DispatchQueue.main.async {
                    self.router.showDishesPick(mealId: meal.id, preselectedDishes: preselectedDishIds) { selectedDishIds in
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
    
    func navigateBackTapped() {
        
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
        let sumProteins = meal.dishes.reduce(0, { sum, mealDish in
            return sum + mealDish.weight / 100 * mealDish.dish.proteins
        })
        let sumFats = meal.dishes.reduce(0, { sum, mealDish in
            return sum + mealDish.weight / 100 * mealDish.dish.fats
        })
        let sumCarbs = meal.dishes.reduce(0, { sum, mealDish in
            return sum + mealDish.weight / 100 * mealDish.dish.carbs
        })
        let sumKcals = meal.dishes.reduce(0, { sum, mealDish in
            return sum + mealDish.weight / 100 * mealDish.dish.calories
        })
        DispatchQueue.main.async {
            viewState.error = nil
            viewState.date = mealDate
            viewState.dishItems = dishItems
            viewState.sumProteins = String(sumProteins)
            viewState.sumFats = String(sumFats)
            viewState.sumCarbs = String(sumCarbs)
            viewState.sumKcals = String(sumKcals)
        }
    }
    
    private func mapToListItem(_ mealDish: MealDish) -> MealDishesListItem {
        let dish = mealDish.dish
        let formatter = Formatter.dishNumbers
        let calString = formatter.string(for: dish.calories) ?? "0"
        let proteinsString = formatter.string(for: dish.proteins) ?? "0"
        let fatsString = formatter.string(for: dish.fats) ?? "0"
        let carbsString = formatter.string(for: dish.carbs) ?? "0"
        let categoryColor: UIColor? = if let category = dish.category {
            try? .init(hex: category.colorHex)
        } else {
            nil
        }
        let item = MealDishesListItem(id: mealDish.id,
                                      name: dish.name,
                                      subtitle: "\(calString) kcal \(proteinsString)/\(fatsString)/\(carbsString)",
                                      weight: NumberFormatter.dishNumbers.string(for: mealDish.weight) ?? "0",
                                      categoryColor: categoryColor)
        return item
    }
}
