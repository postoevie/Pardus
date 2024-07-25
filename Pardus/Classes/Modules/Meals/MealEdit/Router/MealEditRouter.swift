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
    
    func showDishesPick(preselectedDishes: [UUID], completion: @escaping (Set<UUID>) -> Void) {
        navigation.items.append(.picklist(callingView: .mealEdit(mealId: nil), // TODO: Consider nil as non-correct value
                                          preselected: Set(preselectedDishes),
                                          completion: completion))
    }
}
