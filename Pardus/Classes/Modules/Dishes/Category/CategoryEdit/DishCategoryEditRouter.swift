//
//  DishCategoryEditRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 1.12.24..
//

final class DishCategoryEditRouter: CategoryEditRouterProtocol {
    
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType) {
        self.navigation = navigation
    }
    
    func returnBack() {
        _ = navigation.dishesItems.popLast()
    }
}
