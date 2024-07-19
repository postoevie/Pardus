//
//  DishEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//


import SwiftUI

final class DishEditAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = DishEditRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let restoration = container.resolve(CoreDataRestorationStoreAssembly.self).build()
        let restorated = restoration.restore(key: .dishEdit)
        let coreDataService = CoreDataEntityService(context: restorated?.context ?? coreDataStackService.makeChildMainQueueContext(),
                                                    caches: restorated?.entityCaches ?? [:],
                                                    restoration: restoration)
        let interactor = DishEditInteractor(modelService: coreDataService, mealId: nil)

        //ViewState
        let viewState =  DishEditViewState()

        // Presenter
        let presenter = DishEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        viewState.set(with: presenter)
        
        // View
        let view = DishEditView(viewState: viewState, presenter: presenter)
        return view
    }
}
