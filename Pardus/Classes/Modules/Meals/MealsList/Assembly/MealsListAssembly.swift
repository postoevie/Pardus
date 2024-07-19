//
//  MealsListAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//


import SwiftUI

final class MealsListAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = MealsListRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let restoration = container.resolve(CoreDataRestorationStoreAssembly.self).build()
        let restorated = restoration.restore(key: .mealsList)
        let coreDataService = CoreDataEntityService(context: restorated?.context ?? coreDataStackService.makeChildMainQueueContext(),
                                                    caches: restorated?.entityCaches ?? [:],
                                                    restoration: restoration)
        let interactor = MealsListInteractor(modelService: coreDataService)
        
        //ViewState
        let viewState = MealsListViewState()
        
        // Presenter
        let presenter = MealsListPresenter(router: router,
                                           interactor: interactor,
                                           viewState: viewState)
        
        viewState.set(presenter: presenter)
        
        // View
        let view = MealsListView(viewState: viewState, presenter: presenter)
        return view
    }
}
