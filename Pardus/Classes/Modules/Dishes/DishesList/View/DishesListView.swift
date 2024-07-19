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
        List {
            ForEach(viewState.dishesList) { dish in
                DishesListCell(dish: dish)
            }
            .onDelete(perform: { indexSet in
                presenter.delete(indexSet: indexSet)
            })
        }
        .navigationTitle("Dishes")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.tapAddNew()
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

struct DishesListCell: View {
    
    var dish: DishViewModel
    
    var body: some View {
        HStack {
            Text(dish.name)
        }
    }
}

struct DishesListPreviews: PreviewProvider {
    static var previews: some View {
        ApplicationViewBuilder.stub.build(view: .dishList)
    }
}

