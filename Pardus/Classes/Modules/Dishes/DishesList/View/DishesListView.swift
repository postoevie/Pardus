//
//  DishesListView.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//
//

import SwiftUI

struct DishesListView: View {
    
    @StateObject var viewState: DishesListViewState
    @StateObject var presenter: DishesListPresenter
    
    var body: some View {
        VStack {
            TextField("Name", text: $viewState.searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
            List {
                ForEach(viewState.dishesList) { dish in
                    VStack {
                        HStack {
                            Text(dish.name)
                                .foregroundStyle(Color(UIColor.black))
                                .font(Font.custom("RussoOne", size: 14))
                            Circle()
                                .frame(width: 16)
                                .foregroundStyle(Color(dish.categoryColor ?? UIColor.white))
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 10)
                        HStack {
                            Text("300/150/200 1000")
                                .foregroundStyle(Color(UIColor.lightGray))
                                .font(Font.custom("RussoOne", size: 10))
                            Spacer()
                        }
                    }
                    .frame(minHeight: 40)
                    .swipeActions {
                        Button {
                            presenter.tapEditDish(dishId: dish.id)
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .tint(.orange)
                        Button {
                            presenter.delete(dishId: dish.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .listStyle(.plain)
            .padding(.trailing)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.tapGroup()
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem {
                Button {
                    presenter.tapNewDish()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
        }
        .navigationTitle("Dishes")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            presenter.didAppear()
        }
    }
}

struct DishesListPreviews: PreviewProvider {
   
    static var previews: some View {
        //ViewState
        let viewState = DishesListViewState()
        // Presenter
        let presenter = DishesListPresenter(router: MockDishesListRouter(),
                                            interactor: MockDishesListInteractor(),
                                            viewState: viewState)
        viewState.set(with: presenter)
        return DishesListView(viewState: viewState, presenter: presenter)
    }
    
    class MockDishesListRouter: DishesListRouterProtocol {
        func showSections() {
            
        }
        
        func showEditDish(dishId: UUID) {
            
        }
        
        
        func showAddDish() {
            
        }
        
        func showAddCategory() {
            
        }
        
        func showEditCategory(dishCategoryId: UUID) {
            
        }
    }
    
    class MockDishesListInteractor: DishesListInteractorProtocol {
        func deleteDishCategory(categoryId: UUID) async throws {
            
        }
        
        func deleteDish(dishId: UUID) async throws {
            
        }
        
        var dishCategories: [DishCategoryModel] = [
            .init(id: UUID(), name: "Fish", colorHex: "4484FF", objectId: nil),
            .init(id: UUID(), name: "Meat", colorHex: "F97E57", objectId: nil),
            .init(id: UUID(), name: "Veggie", colorHex: "2EB14B", objectId: nil),
        ]
        var dishes: [DishModel] = []
        
        var filteredDishes: [DishModel] = []
        
        init() {
            dishes = [.init(id: UUID(), name: "Уха", category: dishCategories[0], objectId: nil),
                      .init(id: UUID(), name: "Tuna sandwich", category: dishCategories[0], objectId: nil),
                      .init(id: UUID(), name: "Meat balls", category: dishCategories[1], objectId: nil),
                      .init(id: UUID(), name: "Fried chicken", category: dishCategories[1], objectId: nil),]
            filteredDishes = dishes
        }
        
        func setFilterText(_ text: String) {
            filteredDishes = dishes.filter { $0.name.hasPrefix(text) }
        }
        
        func loadDishes() async throws {
            
        }
        
        func deleteDishes(indexSet: IndexSet) async throws {
            
        }
        
        func stashState() {
            
        }
    }
}

