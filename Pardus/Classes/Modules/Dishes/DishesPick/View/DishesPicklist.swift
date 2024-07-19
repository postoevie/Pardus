//
//  DishesPicklist.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import SwiftUI

struct DishesPicklist: View {
           
    @StateObject var viewState: DishesPicklistState
    @StateObject var presenter: DishesPickPresenter
    
    var body: some View {
        List(viewState.dishes, id: \.self) { dish in
            Button {
                presenter.setSelected(dish: dish)
            } label: {
                HStack {
                    Text(dish.name)
                    Spacer()
                }
            }
            .background(viewState.selectedDishes.contains(dish) ? Color(.green) : Color(.gray))
            .listRowBackground(Color.clear)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.doneTapped()
                } label: {
                    Text("Save")
                }
            }
        }
        .onAppear {
            presenter.didAppear()
        }
    }
}

struct DishesPickPreviews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        //ApplicationViewBuilder.stub.build(view: .dishesPick)
    }
}

