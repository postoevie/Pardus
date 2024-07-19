//
//  DishesPickAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//


import SwiftUI

final class DishesPickAssembly: Assembly {
    
    func build(callingView: Views, _ preselected: [UUID], _ completion: @escaping ([UUID]) -> Void) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = DishesPickRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let restoration = container.resolve(CoreDataRestorationStoreAssembly.self).build()
        let restorated = restoration.restore(key: callingView)
        let coreDataService = CoreDataEntityService(context: restorated?.context ?? coreDataStackService.makeChildMainQueueContext(),
                                                    caches: [:],
                                                    restoration: nil)
        let interactor = DishesPickInteractor(modelService: coreDataService, preselectedDishesIds: preselected)

        // Presenter
        let presenter = DishesPickPresenter(router: router, interactor: interactor, completion: completion)
        
        //ViewState
        let viewState = DishesPicklistState()
        presenter.viewState = viewState
        
        // View
        let view = DishesPicklist(viewState: viewState, presenter: presenter)
        return view
    }
}
