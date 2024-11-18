//
//  IngridientCategoriesListAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 14.11.24..
//

import SwiftUI

final class IngridientCategoriesListAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .ingridients)
        
        // Router
        let router = IngridientCategoriesListRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = CategoriesListInteractor<IngridientCategory,
                                                  Ingridient,
                                                  CategoriesListInteractorCustomizer>(coreDataService: coreDataService,
                                                                                      customizer: CategoriesListInteractorCustomizer())
        
        //ViewState
        let viewState = CategoriesListViewState()
        
        // Presenter
        let presenter = CategoriesListPresenter<IngridientCategory,
                                                Ingridient,
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

    func getDetailEntities(mainEntity: IngridientCategory) -> [Ingridient] {
        Array(mainEntity.ingridients)
    }
    
    func getOrphanEntities(detailEntities: [Ingridient]) -> [Ingridient] {
        detailEntities.filter { $0.category == nil }
    }
}

fileprivate struct CategoriesListPresenterCustomizer: CategoriesListPresenterCustomizerProtocol {
    
    func getNavigationTitle() -> String {
        "Categories"
    }
    
    func makeListSections(data: [CategoriesListDataItem<IngridientCategory, Ingridient>]) -> [CategoriesListSection] {
        data.map { item in
            let category = item.mainEntity
            let ingridients = item.detailEntities
            let color: UIColor? = if let colorHex = category?.colorHex {
                try? .init(hex: colorHex)
            } else {
                nil
            }
            let dishItems = ingridients.map { ingridient in
                let subtitle = Formatter.nutrientsDefaultString(calories: ingridient.calories,
                                                                proteins: ingridient.proteins,
                                                                fats: ingridient.fats,
                                                                carbs: ingridient.carbs)
                return CategoriesListItem(id: ingridient.id,
                                          title: ingridient.name,
                                          subtitle: subtitle,
                                          categoryColor: .clear)
            }
            return CategoriesListSection(categoryId: category?.id,
                                         title: category?.name ?? "No Category",
                                         color: color ?? .lightGray,
                                         dishes: dishItems)
        }
    }
}

