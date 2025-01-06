//
//  DishCategoriesPicklistAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 1.11.24..
//

import SwiftUI

final class DishCategoriesPicklistAssembly: Assembly {
    
    func build(type: PicklistType,
               filter: Predicate?,
               completion: @escaping (Set<UUID>) -> Void) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()
        
        // Router
        let router = PicklistRouter(navigation: navigation)
        
        // Interactor
        let sortParams = SortParams(fieldName: (\DishCategory.name).fieldName, ascending: true)
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = PicklistInteractor<DishCategory>(coreDataService: coreDataService,
                                                          type: type,
                                                          filterPredicate: filter,
                                                          sortParams: sortParams)
        
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
