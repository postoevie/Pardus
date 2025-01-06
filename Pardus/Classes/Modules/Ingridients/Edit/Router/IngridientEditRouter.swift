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
    
    init(navigation: any NavigationServiceType) {
        self.navigation = navigation
    }
    
    func returnBack() {
        _ = navigation.ingridientsItems.popLast()
    }
    
    func hidePicklist() {
        _ = navigation.modalView = nil
    }
    
    func showPicklist(ingridientId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void) {
        navigation.modalView = .ingridientCategoryPicklist(type: .singular,
                                                           filter: filter,
                                                           completion: completion)
    }
}
