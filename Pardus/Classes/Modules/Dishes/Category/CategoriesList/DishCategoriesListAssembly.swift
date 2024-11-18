//
//  CategoriesListAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//
//

import SwiftUI

final class DishCategoriesListAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .dishes)
        
        // Router
        let router = DishCategoriesListRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = CategoriesListInteractor<DishCategory,
                                                  Dish,
                                                  CategoriesListInteractorCustomizer>(coreDataService: coreDataService, customizer: CategoriesListInteractorCustomizer())
        
        //ViewState
        let viewState = CategoriesListViewState()
        
        // Presenter
        let presenter = CategoriesListPresenter<DishCategory,
                                                Dish,
                                                CategoriesListInteractor,
                                                CategoriesListPresenterCustomizer>(router: router,
                                                                                   interactor: interactor,
                                                                                   viewState: viewState,
                                                                                   customizer: CategoriesListPresenterCustomizer())
        
        // View
        let view = CategoriesListView(viewState: viewState, presenter: presenter)
        return view
    }
}

fileprivate struct CategoriesListInteractorCustomizer: CategoriesListInteractorCustomizerProtocol {
    
    func getDetailEntities(mainEntity: DishCategory) -> [Dish] {
        Array(mainEntity.dishes)
    }
    
    func getOrphanEntities(detailEntities: [Dish]) -> [Dish] {
        detailEntities.filter { $0.category == nil }
    }
}

fileprivate struct CategoriesListPresenterCustomizer: CategoriesListPresenterCustomizerProtocol {
    
    typealias MainEntity = DishCategory
    typealias DetailEntity = Dish
    
    func getNavigationTitle() -> String {
        "Categories"
    }
    
    func makeListSections(data: [CategoriesListDataItem<MainEntity, DetailEntity>]) -> [CategoriesListSection] {
        data.map { item in
            let category = item.mainEntity
            let dishes = item.detailEntities
            let color: UIColor? = if let colorHex = category?.colorHex {
                try? .init(hex: colorHex)
            } else {
                nil
            }
            let dishItems = dishes.map { dish in
                let ingridientNames = (dish.ingridients ?? []).map {
                    $0.name
                }
                return CategoriesListItem(id: dish.id,
                                          title: dish.name,
                                          subtitle: ingridientNames.joined(separator: ", "),
                                          categoryColor: .clear)
            }
            return CategoriesListSection(categoryId: category?.id,
                                         title: category?.name ?? "No Category",
                                         color: color ?? .lightGray,
                                         dishes: dishItems)
        }
    }
}
