//
//  MealEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI
import Combine

final class MealDishEditPresenter: MealDishEditPresenterProtocol {
    
    private let router: MealDishEditRouterProtocol
    private let interactor: MealDishEditInteractorProtocol
    private weak var viewState: (any MealDishEditViewStateProtocol)?
    
    var subscriptions = [AnyCancellable]()
    
    init(router: MealDishEditRouterProtocol,
         interactor: MealDishEditInteractorProtocol,
         viewState: (any MealDishEditViewStateProtocol)?) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func didAppear() {
        Task {
            try await interactor.loadInitialMealDish()
            try await interactor.performWithMealDish { mealDish in
                self.updateViewState(mealDish: mealDish)
            }
        }
    }
    
    func submitValues() {
        guard let viewState else {
            return
        }
        Task {
            try await interactor.performWithMealDish { mealDish in
                mealDish?.name = viewState.name
            }
            try await interactor.save()
        }
    }
    
    func updateIngridientWeight(ingridientId: UUID) {
        guard let viewState,
              let ingridient = viewState.ingridients.first(where: { $0.id == ingridientId }) else {
            return
        }
        Task {
            let weightString = ingridient.weight
            let weight: NSNumber = NumberFormatter.nutrients.number(from: weightString) ?? .init(value: 0)
            try await interactor.performWithMealDish { mealDish in
                let ingiridient = mealDish?.ingridients?[ingridientId]
                ingiridient?.weight = weight.doubleValue
                self.updateViewState(mealDish: mealDish)
            }
        }
    }
    
    func addCatalogIngridientsTapped() {
        guard let mealDishId = self.interactor.mealDishId else {
            return
        }
        Task {
            let filter = self.interactor.ingridientsFilter
            await MainActor.run {
                self.router.showIngidientsPicklist(dishMealId: mealDishId, filter: filter) { selectedIngridientsIds in
                    self.router.hidePicklist()
                    Task {
                        try await self.interactor.setSelectedIngridients(selectedIngridientsIds)
                        try await self.interactor.save()
                        try await self.interactor.performWithMealDish { mealDish in
                            self.updateViewState(mealDish: mealDish)
                        }
                    }
                }
            }
        }
    }
    
    func createIngridientTapped() {
        Task {
            let ingridientId = try await interactor.createMealIngridient()
            try await interactor.save()
            await MainActor.run {
                router.showMealIngridient(ingridientId: ingridientId)
            }
        }
    }
    
    func removeIngridientTapped(ingridientId: UUID) {
        Task {
            try await interactor.remove(ingridientId: ingridientId)
            try await interactor.save()
            try await interactor.performWithMealDish { mealDish in
                self.updateViewState(mealDish: mealDish)
            }
        }
    }
    
    func editIngridientTapped(ingridientId: UUID) {
        router.showMealIngridient(ingridientId: ingridientId)
    }

    func doneTapped() {
        Task {
            try await interactor.save()
            await MainActor.run {
                router.returnBack()
            }
        }
    }
    
    private func updateViewState(mealDish: MealDish?) {
        guard let viewState = self.viewState else {
            return
        }
        guard let mealDish else {
            DispatchQueue.main.async {
                viewState.error = "errors.absendentity"
            }
            return
        }
        
        let name = String(mealDish.name)
        let sumKcals = String(mealDish.calories)
        let weight = String(mealDish.weight)
        let sumProteins = String(mealDish.proteins)
        let sumFats = String(mealDish.fats)
        let sumCarbs = String(mealDish.carbs)
        let ingridients = (mealDish.ingridients ?? []).map(self.mapToListItem)
        
        DispatchQueue.main.async {
            viewState.error = nil
            viewState.name = name
            viewState.ingridients = ingridients
            viewState.weight = String(weight)
            viewState.sumKcals = String(sumKcals)
            viewState.sumProteins = String(sumProteins)
            viewState.sumFats = String(sumFats)
            viewState.sumCarbs = String(sumCarbs)
        }
    }
    
    private func mapToListItem(_ ingridient: MealIngridient) -> MealDishesIngridientsListItem {
        let formatter = Formatter.nutrients
        let calString = formatter.string(for: ingridient.calories) ?? "0"
        let proteinsString = formatter.string(for: ingridient.proteins) ?? "0"
        let fatsString = formatter.string(for: ingridient.fats) ?? "0"
        let carbsString = formatter.string(for: ingridient.carbs) ?? "0"
        var categoryColor: Color = .clear
        if let colorHex = ingridient.ingridient?.category?.colorHex,
           let color = try? UIColor.init(hex: colorHex) {
            categoryColor = Color(color)
        }
        let item = MealDishesIngridientsListItem(id: ingridient.id,
                                                 title: ingridient.name,
                                                 subtitle: "\(calString) kcal \(proteinsString)/\(fatsString)/\(carbsString)",
                                                 weight: NumberFormatter.nutrients.string(for: ingridient.weight) ?? "0",
                                                 categoryColor: categoryColor)
        return item
    }
}
