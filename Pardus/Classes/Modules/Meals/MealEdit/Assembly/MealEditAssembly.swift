//
//  MealEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//


import SwiftUI

final class MealEditAssembly: Assembly {
    
    func build(mealId: UUID?) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .meals)
        
        // Router
        let router = MealEditRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.makeChildMainQueueContext())
        let interactor = MealEditInteractor(dataService: coreDataService, mealId: mealId)
        
        //ViewState
        let viewState =  MealEditViewState()
        
        // Presenter
        let presenter = MealEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = MealEditView(viewState: viewState, presenter: presenter)
        return view
    }
    
    func preview() -> some View {
        makePreviewEditView()
    }
    
    func makePreviewEditView() -> MealEditView {
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .meals)
        
        // Router
        let router = MealEditRouter(navigation: navigation)
        
        let coreDataStackService = CoreDataStackInMemoryService()
        
        let context = coreDataStackService.getMainQueueContext()
        
        let dishCategory = DishCategory(context: context)
        dishCategory.name = "Salads"
        dishCategory.colorHex = "#00AA00"
        dishCategory.id = UUID()
        
        let dish = Dish(context: context)
        dish.id = UUID()
        dish.name = "Carrot salad 🥕"
        dish.category = dishCategory
        dish.proteins = 30
        dish.fats = 50
        dish.carbs = 20
        dish.calories = 130
        
        let soup = Dish(context: context)
        soup.id = UUID()
        soup.name = "Soup 🍜"
        soup.category = dishCategory
        soup.proteins = 50
        soup.fats = 30
        soup.carbs = 15
        soup.calories = 200
        
        let meal = Meal(context: context)
        meal.id = UUID()
        meal.date = Date()
        meal.dishes = Set()
    
        let mealDish = MealDish(context: context)
        mealDish.id = UUID()
        mealDish.weight = 100
        
        let soupMealDish = MealDish(context: context)
        soupMealDish.id = UUID()
        soupMealDish.weight = 300
        
        mealDish.meal = meal
        mealDish.dish = dish
        
        soupMealDish.meal = meal
        soupMealDish.dish = soup
        
        try? context.save()
        
        let interactor = PreviewInteractor()
        
        interactor.meal = meal
        
        //ViewState
        let viewState =  MealEditViewState()
        
        // Presenter
        let presenter = MealEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = MealEditView(viewState: viewState, presenter: presenter)
        return view
    }
}

private class PreviewInteractor: MealEditInteractorProtocol {
    
    var meal: Meal?
    
    func performWithMeal(action: @escaping (Meal?) -> Void) async throws {
        action(self.meal)
    }
    
    func updateMealDish(dishId: UUID, action: @escaping (MealDish?) -> Void) async throws {
        guard let meal,
              let mealDish = meal.dishes[dishId] else {
            print("no meal")
            return
        }
        action(mealDish)
    }
    
    func remove(dishId: UUID) async throws {
        
    }
    
    func setSelectedDishes(_ dishesIds: Set<UUID>) async throws {
        
    }
    
    func loadInitialMeal() async throws {
        
    }
    
    func save() async throws {
        
    }
}
