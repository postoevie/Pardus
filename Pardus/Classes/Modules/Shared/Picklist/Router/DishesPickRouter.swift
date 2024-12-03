//
//  DishesPickRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import Foundation

final class PicklistRouter: PicklistRouterProtocol {
    
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
    
    func dismiss() {
        navigation.modalView = nil
    }
}
