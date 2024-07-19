//
//  DishEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

final class DishEditViewState: ObservableObject, DishEditViewStateProtocol {
    
    var name: String = ""
    var error: String?
    
    private let id = UUID()
    private var presenter: DishEditPresenterProtocol?
    
    func set(with presener: DishEditPresenterProtocol) {
        self.presenter = presener
    }
}
