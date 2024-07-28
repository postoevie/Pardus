//
//  DishesPickAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//
//


import SwiftUI

final class PicklistAssembly: Assembly {
    
    func build(callingView: Views, _ preselected: Set<UUID>, _ completion: @escaping (Set<UUID>) -> Void) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()
        
        // Router
        let router = PicklistRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let restoration = container.resolve(CoreDataRestorationStoreAssembly.self).build()
        let restorated = restoration.restore(key: callingView)
        let coreDataService = CoreDataEntityService(context: restorated?.context ?? coreDataStackService.makeChildMainQueueContext(),
                                                    caches: [:],
                                                    restoration: nil)
        let interactor: PicklistInteractorProtocol = switch callingView {
        case .dishEdit:
            DishCategoriesPicklistInteractor(modelService: coreDataService, preselectedCategoryIds: preselected)
        default:
            DishesPicklistInteractor(modelService: coreDataService, preselectedDishesIds: preselected)
        }
        
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
        
        let navigation = container.resolve(NavigationAssembly.self).build()
        
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
        
        var selectedItemIds: Set<UUID> = Set()
        
        var items: [PicklistDataItem] {
            dishCategories.map { .dishCategory($0) }
        }
        
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
        
        var selectedItems: [PicklistDataItem] = []
        
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
