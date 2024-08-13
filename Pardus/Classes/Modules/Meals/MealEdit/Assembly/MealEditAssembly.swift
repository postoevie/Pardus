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
        let coreDataService = CoreDataEntityService(context: coreDataStackService.makeChildMainQueueContext())
        let interactor = MealEditInteractor(modelService: coreDataService, mealId: mealId)
        
        //ViewState
        let viewState =  MealEditViewState()
        
        // Presenter
        let presenter = MealEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = MealEditView(viewState: viewState, presenter: presenter)
        return view
    }
    
    func preview() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .meals)
        
        // Router
        let router = MealEditRouter(navigation: navigation)
        
        let interactor = PreviewInteractor()
        
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
    
    func remove(dishId: UUID) async throws {
        
    }
    
    func setSelectedDishes(_ dishesIds: Set<UUID>) async throws {
        
    }
    
    var meal: MealModel? = .init(id: UUID(),
                                 date: Date(),
                                 dishes: [.init(id: UUID(),
                                                name: "Raspberry pie",
                                                category: .init(id: UUID(),
                                                                name: "",
                                                                colorHex: "A0BCCF",
                                                                objectId: nil),
                                                calories: 0,
                                                proteins: 0,
                                                fats: 0,
                                                carbohydrates: 0,
                                                objectId: nil),
                                          .init(id: UUID(),
                                                name: "Paela",
                                                category: .init(id: UUID(),
                                                                name: "",
                                                                colorHex: "FBA011",
                                                                objectId: nil),
                                                calories: 0,
                                                proteins: 0,
                                                fats: 0,
                                                carbohydrates: 0,
                                                objectId: nil)])
    
    func loadInitialMeal() async throws {
        
    }
    
    func update(model: MealModel) async throws {
        
    }
    
    func save() async throws {
        
    }
}
