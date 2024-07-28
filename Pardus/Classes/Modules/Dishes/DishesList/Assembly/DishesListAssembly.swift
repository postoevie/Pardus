//
//  DishesListAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//


import SwiftUI

final class DishesListAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = DishesListRouter(navigation: navigation)

        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataEntityService(context: coreDataStackService.makeChildMainQueueContext(),
                                                    caches: [:],
                                                    restoration: nil)
        // Interactor
        let interactor = DishesListInteractor(modelService: coreDataService)

        //ViewState
        let viewState = DishesListViewState()

        // Presenter
        let presenter = DishesListPresenter(router: router, interactor: interactor, viewState: viewState)
        
        viewState.set(with: presenter)
        
        // View
        let view = DishesListView(viewState: viewState, presenter: presenter)
        return view
    }
    
    func preview() -> some View {
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = DishesListRouter(navigation: navigation)

        // Interactor
        let interactor = DishesListPreviewInteractor()

        //ViewState
        let viewState = DishesListViewState()

        // Presenter
        let presenter = DishesListPresenter(router: router, interactor: interactor, viewState: viewState)
        
        viewState.set(with: presenter)
        
        // View
        let view = DishesListView(viewState: viewState, presenter: presenter)
        return view
    }
    
    private class DishesListPreviewInteractor: DishesListInteractorProtocol {
        func deleteDishCategory(categoryId: UUID) async throws {
            
        }
        
        func deleteDish(dishId: UUID) async throws {
            
        }
        
        var dishCategories: [DishCategoryModel] = [
            .init(id: UUID(), name: "Fish", colorHex: "4484FF", objectId: nil),
            .init(id: UUID(), name: "Meat", colorHex: "F97E57", objectId: nil),
            .init(id: UUID(), name: "Veggie", colorHex: "2EB14B", objectId: nil),
        ]
        var dishes: [DishModel] = []
        
        var filteredDishes: [DishModel] = []
        
        init() {
            dishes = [.init(id: UUID(), name: "Уха", category: dishCategories[0], objectId: nil),
                      .init(id: UUID(), name: "Tuna sandwich", category: dishCategories[0], objectId: nil),
                      .init(id: UUID(), name: "Meat balls", category: dishCategories[1], objectId: nil),
                      .init(id: UUID(), name: "Fried chicken", category: dishCategories[1], objectId: nil),]
            filteredDishes = dishes
        }
        
        func setFilterText(_ text: String) {
            filteredDishes = dishes.filter { $0.name.hasPrefix(text) }
        }
        
        func loadDishes() async throws {
            
        }
        
        func deleteDishes(indexSet: IndexSet) async throws {
            
        }
        
        func stashState() {
            
        }
    }
}
