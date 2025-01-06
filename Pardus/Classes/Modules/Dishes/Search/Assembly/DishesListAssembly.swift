//
//  DishesListAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//
//

import SwiftUI
import CoreData

final class DishesListAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()
        
        // Router
        let router = DishesListRouter(navigation: navigation)
        
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        
        // Interactor
        let sortParams = SortParams(fieldName: (\Dish.name).fieldName, ascending: true)
        let interactor = SearchListInteractor<Dish>(coreDataService: coreDataService,
                                                    sortParams: sortParams)
        
        // ViewState
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
            var categoryColor: Color = .clear
            if let colorHex = entity.category?.colorHex,
               let color = try? UIColor.init(hex: colorHex) {
                categoryColor = Color(color)
            }
            let ingridients = Array(entity.ingridients)
            let ingridientNames = sorted(ingridients: ingridients).map { $0.name }
            return SearchListItem(id: entity.id,
                                  title: entity.name,
                                  subtitle: ingridientNames.joined(separator: ", "),
                                  categoryColor: categoryColor)
        }
        
        private func sorted(ingridients: [Ingridient]) -> [Ingridient] {
            ingridients.sorted {
                $0.name < $1.name
            }
        }
    }
}
