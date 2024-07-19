//
//  DishesListRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import Foundation

final class DishesListRouter: DishesListRouterProtocol {

    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func showAdd() {
        navigation.items.append(.dishEdit(dishId: nil))
    }
    
    func showEdit(dishId: UUID) {
        navigation.items.append(.dishEdit(dishId: dishId))
    }
}
