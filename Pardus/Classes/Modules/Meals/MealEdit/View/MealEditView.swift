//
//  MealEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

struct MealEditView: View {
           
    @StateObject var viewState: MealEditViewState
    @StateObject var presenter: MealEditPresenter
    @State var dishList = ["Dish1", "Dish2", "Dish3", "Dish4"]
    
    var body: some View {
        VStack {
            DatePicker(
                "Date",
                selection: $viewState.date,
                displayedComponents: [.date, .hourAndMinute]
            )
            List(viewState.dishes, id: \.self) { dish in
                Text(dish)
                    .listRowBackground(Color.clear)
            }
            Spacer()
        }
        .onAppear {
            presenter.didAppear()
        }
        .padding(8)
        .navigationTitle("Meal editing")
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.editTapped()
                } label: {
                    Text("Edit dishes")
                }
            }
            ToolbarItem {
                Button {
                    presenter.doneTapped()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct MealEditPreviews: PreviewProvider {
    static var previews: some View {
        ApplicationViewBuilder.stub.build(view: .mealEdit(mealId: nil))
    }
}

