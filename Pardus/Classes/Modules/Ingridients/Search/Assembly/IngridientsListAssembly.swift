//
//  IngridientsListAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 29.10.24.
//
//

import SwiftUI

final class IngridientsListAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .ingridients)
        
        // Router
        let router = IngridientsListRouter(navigation: navigation)
        
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        
        // Interactor
        let interactor = SearchListInteractor<Ingridient>(coreDataService: coreDataService)
        
        //ViewState
        let viewState = SearchListViewState()
        
        // Presenter
        let presenter = SearchListPresenter<Ingridient,
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
    
        var navigationTitle: LocalizedStringKey { LocalizedStringKey("ingridientslist.navigation.title") }
        
        func mapToItem(entity: Ingridient) -> SearchListItem {
            var categoryColor: UIColor?
            if let colorHex = entity.category?.colorHex {
                categoryColor = try? .init(hex: colorHex)
            }
            let nutrientsString = NumberFormatter.nutrientsDefaultString(calories: entity.calories,
                                                                         proteins: entity.proteins,
                                                                         fats: entity.fats,
                                                                         carbs: entity.carbs)
            return SearchListItem(id: entity.id,
                                  title: entity.name,
                                  subtitle: nutrientsString,
                                  categoryColor: categoryColor ?? .clear)
        }
    }
}
