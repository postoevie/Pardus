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
        let presenter = SearchListPresenter<Dish,
                                            SearchListInteractor,
                                            SearchListPresenterCustomizer>(router: router,
                                                                           viewState: viewState,
                                                                           interactor: interactor,
                                                                           customizer: SearchListPresenterCustomizer())
        
        viewState.set(with: presenter)
        
        // View
        let view = SearchListView(viewState: viewState, presenter: presenter)
        return view
    }
    
    fileprivate struct SearchListPresenterCustomizer: SearchListPresenterCustomizerProtocol {
        
        var navigationTitle: LocalizedStringKey { LocalizedStringKey("disheslist.navigation.title") }
        
        func mapToItem(entity: Dish) -> SearchListItem {
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
    }
}
