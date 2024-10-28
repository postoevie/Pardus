//
//  MealsListAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//


import SwiftUI

final class MealsListAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .meals)
        
        // Router
        let router = MealsListRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let dataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = MealsListInteractor(dataService: dataService)
        
        //ViewState
        let viewState = MealsListViewState()
        
        // Presenter
        let presenter = MealsListPresenter(router: router,
                                           interactor: interactor,
                                           viewState: viewState)
        
        viewState.set(presenter: presenter)
        
        // View
        let view = MealsListView(viewState: viewState, presenter: presenter)
        return view
    }
    
    func preview() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build(stem: .meals)
        
        // Router
        let router = MealsListRouter(navigation: navigation)
    
        let interactor = MockInteractor()
        
        //ViewState
        let viewState = MealsListViewState()
        
        // Presenter
        let presenter = MealsListPresenter(router: router,
                                           interactor: interactor,
                                           viewState: viewState)
        
        viewState.set(presenter: presenter)
        
        // View
        let view = MealsListView(viewState: viewState, presenter: presenter)
        return view
    }
    
    private class MockInteractor: MealsListInteractorProtocol {
        
        func performWithMeals(action: @escaping ([Meal]) -> Void) async throws {
            
        }
        
        var endDate = Date()
        
        var dateFilterEnabled: Bool = false
        
        var startDate = Date()
        
        func delete(itemId: UUID) async throws {
            mealModels = mealModels.filter {
                $0.id != itemId
            }
        }
        
        static let formatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            return formatter
        }()
        
        var mealModels: [MealModel] = [
            .init(id: UUID(),
                  date: formatter.date(from: "25-07-2024 11:12") ?? Date(),
                  dishes: [.init(id: UUID(),
                                 name: "Salad",
                                 category: nil,
                                 calories: 50,
                                 proteins: 50,
                                 fats: 50,
                                 carbohydrates: 50,
                                 objectId: nil),
                           .init(id: UUID(),
                                 name: "Boiled chicken",
                                 category: nil,
                                 calories: 50,
                                 proteins: 50,
                                 fats: 50,
                                 carbohydrates: 50,
                                 objectId: nil),
                           .init(id: UUID(),
                                 name: "Icecream",
                                 category: nil,
                                 calories: 50,
                                 proteins: 50,
                                 fats: 50,
                                 carbohydrates: 50,
                                 objectId: nil)]),
            .init(id: UUID(),
                  date: formatter.date(from: "14-06-2024 11:12") ?? Date(),
                  dishes: [.init(id: UUID(),
                                 name: "Salad",
                                 category: nil,
                                 calories: 50,
                                 proteins: 50,
                                 fats: 50,
                                 carbohydrates: 50,
                                 objectId: nil),
                           .init(id: UUID(),
                                 name: "Boiled chicken",
                                 category: nil,
                                 calories: 50,
                                 proteins: 50,
                                 fats: 50,
                                 carbohydrates: 50,
                                 objectId: nil),
                           .init(id: UUID(),
                                 name: "Icecream",
                                 category: nil,
                                 calories: 50,
                                 proteins: 50,
                                 fats: 50,
                                 carbohydrates: 50,
                                 objectId: nil)]),
            .init(id: UUID(),
                  date: formatter.date(from: "25-07-2024 11:12") ?? Date(),
                  dishes: [])
        ]
        
        func loadMeals() async throws {
            
        }
        
        func deleteMeals(indexSet: IndexSet) async throws {
            
        }
    }
}
