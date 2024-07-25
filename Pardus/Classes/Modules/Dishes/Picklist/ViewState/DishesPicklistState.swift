//
//  DishesPicklistState.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import SwiftUI

final class PicklistState: ObservableObject, DishesPicklistStateProtocol {    
    
    @Published var searchText: String = ""
    @Published var items: [PicklistViewItem] = []
}
