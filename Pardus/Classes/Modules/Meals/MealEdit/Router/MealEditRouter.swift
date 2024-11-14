//
//  MealEditRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import Foundation

final class MealEditRouter: MealEditRouterProtocol {
    
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func returnBack() {
        _ = navigation.items.popLast()
    }
    
    func showDishesPick(mealId: UUID, filter: Predicate?, completion: @escaping (Set<UUID>) -> Void) {
        navigation.items.append(.dishPicklist(callingView: .mealEdit(mealId: mealId),
                                              type: .multiple,
                                              filter: filter,
                                              completion: completion))
    }
    
    func showEditDish(dishId: UUID) {
        navigation.items.append(.mealDishEdit(mealDishId: dishId))
    }
}
