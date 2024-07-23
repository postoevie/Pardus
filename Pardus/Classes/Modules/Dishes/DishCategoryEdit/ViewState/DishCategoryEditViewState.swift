//
//  DishCategoryEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import SwiftUI

final class DishCategoryEditViewState: ObservableObject, DishCategoryEditViewStateProtocol {    
    
    @Published var name: String = ""
    @Published var color: CGColor = .init(gray: 1, alpha: 1)
}
