//
//  DishesPickAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//
//

import SwiftUI

final class DishPicklistAssembly: Assembly {
    
    func build(type: PicklistType,
               filter: Predicate?,
               completion: @escaping (Set<UUID>) -> Void) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()
        
        // Router
        let router = PicklistRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = PicklistInteractor<Dish>(coreDataService: coreDataService,
                                                  type: type,
                                                  filterPredicate: filter,
                                                  sortParams: SortParams(fieldName: (\Dish.name).fieldName,
                                                                         ascending: true))
        
        // Presenter
        let presenter = PicklistPresenter(router: router, interactor: interactor, completion: completion)
        
        // ViewState
        let viewState = PicklistState()
        presenter.viewState = viewState
        
        // View
        let view = PicklistView(viewState: viewState, presenter: presenter)
        return view
    }
}
