//
//  IngridientCategoriesPicklistAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 6.11.24..
//

import SwiftUI

final class IngridientCategoriesPicklistAssembly: Assembly {
    
    func build(callingView: Views,
               type: PicklistType,
               filter: Predicate?,
               completion: @escaping (Set<UUID>) -> Void) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: callingView.navigationStem)
        
        // Router
        let router = PicklistRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = PicklistInteractor<IngridientCategory>(coreDataService: coreDataService,
                                                                type: type,
                                                                filterPredicate: filter)
        
        // Presenter
        let presenter = PicklistPresenter(router: router, interactor: interactor, completion: completion)
        
        //ViewState
        let viewState = PicklistState()
        presenter.viewState = viewState
        
        // View
        let view = PicklistView(viewState: viewState, presenter: presenter)
        return view
    }
}
