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
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = DishesListRouter(navigation: navigation)

        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let restoration = container.resolve(CoreDataRestorationStoreAssembly.self).build()
        let restorated = restoration.restore(key: .dishList)
        let coreDataService = CoreDataEntityService(context: restorated?.context ?? coreDataStackService.makeChildMainQueueContext(),
                                                    caches: restorated?.entityCaches ?? [:],
                                                    restoration: restoration)
        // Interactor
        let interactor = DishesListInteractor(modelService: coreDataService)

        //ViewState
        let viewState = DishesListViewState()

        // Presenter
        let presenter = DishesListPresenter(router: router, interactor: interactor, viewState: viewState)
        
        viewState.set(with: presenter)
        
        // View
        let view = DishesListView(viewState: viewState, presenter: presenter)
        return view
    }
}
