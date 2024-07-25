//
//  DishEditRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import Foundation

final class DishEditRouter: DishEditRouterProtocol {
    
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func returnBack() {
        _ = navigation.items.popLast()
    }
    
    func hideLast() {
        _ = navigation.items.popLast()
    }
    
    func showPicklist(preselectedCategories: Set<UUID>, completion: @escaping (Set<UUID>) -> Void) {
        navigation.items.append(.picklist(callingView: .dishEdit(dishId: nil), // TODO: Consider nil as non-correct value
                                          preselected: preselectedCategories,
                                          completion: completion))
    }
}
