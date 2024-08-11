//
//  DishCategoryEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import SwiftUI

final class DishCategoryEditAssembly: Assembly {
    
    func build(dishCategoryId: UUID?) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .dishes)

        // Router
        let router = DishCategoryEditRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataEntityService(context: coreDataStackService.makeChildMainQueueContext())
        let interactor = DishCategoryEditInteractor(modelService: coreDataService, categoryId: dishCategoryId)

        //ViewState
        let viewState =  DishCategoryEditViewState()

        // Presenter
        let presenter = DishCategoryEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = DishCategoryEditView(viewState: viewState, presenter: presenter)
        return view
    }
}
