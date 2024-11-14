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
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .dishes)

        // Router
        let router = DishesListRouter(navigation: navigation)

        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        
        // Interactor
        let interactor = SearchListInteractor<Dish>(coreDataService: coreDataService)

        //ViewState
        let viewState = SearchListViewState()

        // Presenter
        let presenter = SearchListPresenter<Dish, SearchListInteractor>(router: router,
                                                                        viewState: viewState,
                                                                        interactor: interactor,
                                                                        entityToListItemMapper: mapToListItem)
        
        viewState.set(with: presenter)
        
        // View
        let view = SearchListView(viewState: viewState, presenter: presenter)
        return view
    }
    
    func preview() -> some View {
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .dishes)

        // Router
        let router = DishesListRouter(navigation: navigation)

        // Interactor
        let interactor = DishesListPreviewInteractor()

        //ViewState
        let viewState = SearchListViewState()

        // Presenter
        let presenter = SearchListPresenter<Dish, DishesListPreviewInteractor>(router: router,
                                                                               viewState: viewState,
                                                                               interactor: interactor,
                                                                               entityToListItemMapper: mapToListItem)
        
        viewState.set(with: presenter)
        
        // View
        let view = SearchListView(viewState: viewState, presenter: presenter)
        return view
    }
    
    private func mapToListItem(_ entity: Dish) -> SearchListItem {
        var categoryColor: UIColor?
        if let colorHex = entity.category?.colorHex {
            categoryColor = try? .init(hex: colorHex)
        }
        let ingridientNames = (entity.ingridients ?? []).map {
            $0.name
        }
        return SearchListItem(id: entity.id,
                              title: entity.name,
                              subtitle: ingridientNames.joined(separator: ", "),
                              categoryColor: categoryColor ?? .clear)
    }
    
    private class DishesListPreviewInteractor: SearchListInteractorProtocol {
        
        typealias Entity = Dish
        
        func loadEntities() async throws {
            
        }
        
        func deleteEntity(entityId: UUID) async throws {
            
        }
        
        func performWithFilteredEntities(action: @escaping ([Dish]) -> Void) async {
            
        }
        
        var dishCategories: [DishCategoryModel] = [
            .init(id: UUID(), name: "Fish", colorHex: "4484FF", objectId: nil),
            .init(id: UUID(), name: "Meat", colorHex: "F97E57", objectId: nil),
            .init(id: UUID(), name: "Veggie", colorHex: "2EB14B", objectId: nil),
        ]
        
        var dishes: [DishModel] = []
        
        var filteredDishes: [DishModel] = []
        
        init() {
            dishes = [.init(id: UUID(), name: "Уха", category: dishCategories[0], calories: 100, proteins: 50, fats: 50, carbohydrates: 50, objectId: nil),
                      .init(id: UUID(), name: "Tuna sandwich", category: dishCategories[0], calories: 100, proteins: 50, fats: 50, carbohydrates: 50,  objectId: nil),
                      .init(id: UUID(), name: "Meat balls", category: dishCategories[1], calories: 100, proteins: 50, fats: 50, carbohydrates: 50,  objectId: nil),
                      .init(id: UUID(), name: "Fried chicken", category: dishCategories[1], calories: 100, proteins: 50, fats: 50, carbohydrates: 50,  objectId: nil),]
            filteredDishes = dishes
        }
        
        func setFilterText(_ text: String) {
            filteredDishes = dishes.filter { $0.name.hasPrefix(text) }
        }
    }
}
