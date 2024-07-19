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
                Button {
                    presenter.tapDish(dish)
                } label: {
                    HStack {
                        Text(dish.name)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 8, height: 10)
                    }
                }
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

struct DishesListPreviews: PreviewProvider {
    static var previews: some View {
        ApplicationViewBuilder.stub.build(view: .dishList)
    }
}

