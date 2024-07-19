//
//  MealsListRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import Foundation

final class MealsListRouter: MealsListRouterProtocol {

    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func showAdd() {
        navigation.items.append(.mealEdit(mealId: nil))
    }
    
    func showEdit(mealId: UUID) {
        navigation.items.append(.mealEdit(mealId: mealId))
    }
}
