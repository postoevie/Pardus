//
//  DishesPickRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import Foundation

final class DishesPickRouter: DishesPickRouterProtocol {
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
}
