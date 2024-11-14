//
//  DishesListView.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//
//

import SwiftUI

struct SearchListView<Presenter: SearchListPresenterProtocol>: View {
    
    @StateObject var viewState: SearchListViewState
    @StateObject var presenter: Presenter
    
    var body: some View {
        VStack {
            TextField("Name", text: $viewState.searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
            List(viewState.items) { item in
                SubtitleCell(title: item.title,
                             subtitle: item.subtitle,
                             color: item.categoryColor)
                .swipeActions {
                    Button {
                        presenter.tapEditEntity(entityId: item.id)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(.orange)
                    Button {
                        presenter.delete(entityId: item.id)
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
                    presenter.tapCategories()
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
                Button {
                    presenter.tapNewEntity()
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

