//
//  RecordsStateSnapshot.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24..
//

import Foundation

struct RecordsStateSnapshot: Codable {
    
    let dishes: [UUID: DishState]
    let dishCategories: [UUID: DishCategoryState]
}

struct DishState: Codable {
    
    let name: String
    let categoryId: UUID?
}

struct DishCategoryState: Codable {
    
    let name: String
}

