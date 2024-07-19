//
//  DishEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

final class DishEditViewState: ObservableObject, DishEditViewStateProtocol {
    
    @Published var name: String = "name in state"
    @Published var error: String?
    
    private let id = UUID()
    private var presenter: DishEditPresenterProtocol?
    
    func set(with presener: DishEditPresenterProtocol) {
        self.presenter = presener
    }
}
