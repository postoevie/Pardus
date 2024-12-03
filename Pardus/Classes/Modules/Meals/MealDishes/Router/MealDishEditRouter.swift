//
//  MealEditRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import Foundation

final class MealDishEditRouter: MealDishEditRouterProtocol {
    
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func returnBack() {
        _ = navigation.mealsItems.popLast()
    }
    
    func showIngidientsPicklist(dishMealId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void) {
        navigation.modalView = .dishIngridientsPicklist(type: .multiple,
                                                        filter: filter,
                                                        completion: completion)
    }
    
    func hidePicklist() {
        navigation.modalView = nil
    }
}
