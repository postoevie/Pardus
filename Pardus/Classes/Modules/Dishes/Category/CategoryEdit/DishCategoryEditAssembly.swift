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
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = DishCategoryEditRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = CategoryEditInteractor<DishCategory>(coreDataService: coreDataService, categoryId: dishCategoryId)

        //ViewState
        let viewState =  CategoryEditViewState()

        // Presenter
        let presenter = CategoryEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = CategoryEditView(viewState: viewState, presenter: presenter)
        return view
    }
}
