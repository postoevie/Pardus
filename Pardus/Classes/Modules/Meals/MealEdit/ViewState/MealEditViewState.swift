//
//  MealEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

final class MealEditViewState: ObservableObject, MealEditViewStateProtocol {
    
    @Published var date: Date = Date()
    @Published var error: String?
    @Published var dishes: [String] = []
}
