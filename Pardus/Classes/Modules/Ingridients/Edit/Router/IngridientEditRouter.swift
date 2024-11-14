//
//  DishEditRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import Foundation

final class IngridientEditRouter: IngridientEditRouterProtocol {
    
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
    
    func showPicklist(ingridientId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void) {
        navigation.items.append(.ingridientCategoryPicklist(callingView: .ingridientEdit(ingridientId: ingridientId),
                                                            type: .singular,
                                                            filter: filter,
                                                            completion: completion))
    }
}
