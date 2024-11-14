//
//  DishesPickAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//
//


import SwiftUI

final class DishPicklistAssembly: Assembly {
    
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
        let interactor = PicklistInteractor<Dish>(coreDataService: coreDataService,
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
    
    func preview(callingView: Views, _ preselected: Set<UUID>, _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: callingView.navigationStem)
        
        // Router
        let router = PicklistRouter(navigation: navigation)
        
        // Interactor
        let interactor = PicklistMockInteractor()
        
        // Presenter
        let presenter = PicklistPresenter(router: router, interactor: interactor, completion: completion)
        
        //ViewState
        let viewState = PicklistState()
        presenter.viewState = viewState
        
        // View
        let view = PicklistView(viewState: viewState, presenter: presenter)
        return view
    }
    
    private class PicklistMockInteractor: PicklistInteractorProtocol {
        var items: [PicklistViewItem] = []
        
        var selectedItemIds: Set<UUID> = Set()

        var dishCategories = [
            DishCategoryModel(id: UUID(),
                              name: "Meat",
                              colorHex: "F7ABF1",
                              objectId: nil),
            DishCategoryModel(id: UUID(),
                              name: "Fish",
                              colorHex: "21ACFA",
                              objectId: nil)
        ]
        
        func setSelected(itemId: UUID) {
            if selectedItemIds.contains(itemId) {
                selectedItemIds = Set()
                return
            }
            selectedItemIds = [itemId]
        }
        
        func loadItems() async throws {
            
        }
    }
}
