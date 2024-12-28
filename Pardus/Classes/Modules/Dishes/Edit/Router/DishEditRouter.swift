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
        _ = navigation.dishesItems.popLast()
    }
    
    func showIngridientsPicklist(dishId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void) {
        navigation.modalView = .dishIngridientsPicklist(type: .multiple,
                                                        filter: filter,
                                                        completion: completion)
    }
    
    func showCategoriesPicklist(dishId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void) {
        navigation.modalView = .dishCategoryPicklist(type: .singular,
                                                     filter: filter,
                                                     completion: completion)
    }
    
    func hidePicklist() {
        _ = navigation.modalView = nil
    }
}
