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
        let coreDataService = CoreDataEntityService(context: coreDataStackService.makeChildMainQueueContext(),
                                                    caches: [:],
                                                    restoration: nil)
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
