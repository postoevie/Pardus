//
//  MainRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import Foundation

final class MainRouter: MainRouterProtocol {
    var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType){
        self.navigation = navigation
    }
       
}
