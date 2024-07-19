//
//  MealsListView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

struct MealsListView: View {
           
    @StateObject var viewState: MealsListViewState
    @StateObject var presenter: MealsListPresenter
    
    var body: some View {
        List {
            ForEach(viewState.mealsList) { meal in
                Button {
                    presenter.tapMeal(meal)
                } label: {
                    HStack {
                        VStack {
                            Text(meal.date.formatted())
                            ForEach(meal.dishes, id: \.id) {
                                Text($0.name)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 8, height: 10)
                    }
                }
            }
            .onDelete(perform: { indexSet in
                presenter.deleteMeals(indexSet: indexSet)
            })
        }
        .navigationTitle("Meals")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.tapAddNewMeal()
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
        .onAppear {
            presenter.didAppear()
        }
    }
}

struct MealsListCell: View {
    
    var meal: MealModel
    var presenter: MealsListPresenter
    
    var body: some View {
        VStack {
            Text(meal.date.formatted())
            ForEach(meal.dishes, id: \.id) {
                Text($0.name)
            }
        }
    }
}

struct MealsListPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ApplicationViewBuilder.stub.build(view: .mealsList)
        }
    }
}

