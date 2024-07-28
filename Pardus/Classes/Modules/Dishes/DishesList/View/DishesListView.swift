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
            List(viewState.items) { item in
                SubtitleCell(title: item.name,
                             subtitle: "200/200/200",
                             color: item.categoryColor ?? .clear)
                .swipeActions {
                    Button {
                        presenter.tapEditDish(dishId: item.id)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(.orange)
                    Button {
                        presenter.delete(dishId: item.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
            .listStyle(.plain)
            .padding(.trailing)
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    presenter.tapGroup()
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
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
        NavigationStack {
            ApplicationViewBuilder.preview.build(view: .dishList)
        }
    }
}

