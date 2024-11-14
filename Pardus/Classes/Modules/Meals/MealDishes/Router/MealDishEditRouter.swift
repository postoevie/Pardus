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
        _ = navigation.items.popLast()
    }
    
    func showIngidientsPicklist(dishMealId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void) {
        navigation.items.append(.dishIngridientsPicklist(callingView: .mealDishEdit(mealDishId: dishMealId),
                                                         type: .multiple,
                                                         filter: filter,
                                                         completion: completion))
    }
}
