//
//  MealsListViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

final class MealsListViewState: ObservableObject, MealsListViewStateProtocol {

    private let id = UUID()
    private var presenter: MealsListPresenterProtocol?
    
    @Published var mealsList: [MealModel] = []
    
    func set(presenter: MealsListPresenterProtocol) {
        self.presenter = presenter
    }
    
    func set(items: [MealModel]) {
        mealsList = items
    }
}

struct MealViewModel: Identifiable {
    let id: UUID
    let date: Date
    let dishNames: [String]

    init(id: UUID, name: String) {
        self.id = id
        self.date = Date()
        dishNames = []
    }
    
    init(model: MealModel) {
        self.id = model.id
        self.date = model.date
        self.dishNames = model.dishes.map { $0.name }
    }
}
