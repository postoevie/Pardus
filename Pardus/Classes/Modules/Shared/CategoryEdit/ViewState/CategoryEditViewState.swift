//
//  DishCategoryEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import SwiftUI

final class CategoryEditViewState: ObservableObject, CategoryEditViewStateProtocol {    
    
    @Published var name: String = ""
    @Published var color: CGColor = UIColor.lightGray.cgColor
}
