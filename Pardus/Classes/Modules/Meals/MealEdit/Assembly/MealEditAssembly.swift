//
//  MealEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//


import SwiftUI

final class MealEditAssembly: Assembly {
    
    func build(mealId: UUID?) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = MealEditRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let restoration = container.resolve(CoreDataRestorationStoreAssembly.self).build()
        let restorated = restoration.restore(key: .mealEdit(mealId: mealId))
        let coreDataService = CoreDataEntityService(context: restorated?.context ?? coreDataStackService.makeChildMainQueueContext(),
                                                    caches: restorated?.entityCaches ?? [:],
                                                    restoration: restoration)
        let interactor = MealEditInteractor(modelService: coreDataService, mealId: mealId)

        //ViewState
        let viewState =  MealEditViewState()

        // Presenter
        let presenter = MealEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = MealEditView(viewState: viewState, presenter: presenter)
        return view
    }
}
