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
    
    func entityshowIngridientsPicklist(dishId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void) {
        navigation.items.append(.dishIngridientsPicklist(callingView: .dishEdit(dishId: dishId),
                                                         type: .multiple,
                                                         filter: filter,
                                                         completion: completion))
    }
    
    func showCategoriesPicklist(dishId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void) {
        navigation.items.append(.dishCategoryPicklist(callingView: .dishEdit(dishId: dishId),
                                                      type: .singular,
                                                      filter: filter,
                                                      completion: completion))
    }
}
