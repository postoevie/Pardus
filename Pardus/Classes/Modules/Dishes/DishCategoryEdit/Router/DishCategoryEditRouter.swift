//
//  DishCategoryEditRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import Foundation

final class DishCategoryEditRouter: DishCategoryEditRouterProtocol {
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func returnBack() {
        _ = navigation.items.popLast()
    }
}
