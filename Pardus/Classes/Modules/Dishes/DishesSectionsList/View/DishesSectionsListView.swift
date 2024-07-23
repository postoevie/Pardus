//
//  DishesSectionsListView.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//
//

import SwiftUI

struct DishesSectionsListView: View {
    
    @StateObject var viewState: DishesSectionsListViewState
    @StateObject var presenter: DishesSectionsListPresenter
    
    var body: some View {
        List {
            ForEach(viewState.sections, id: (\.category.id)) { section in
                HStack {
                    Spacer()
                    Text(section.category.name)
                        .foregroundStyle(Color(UIColor.white))
                        .font(Font.custom("RussoOne", size: 24))
                    Spacer()
                }
                .swipeActions {
                    Button {
                        presenter.tapEdit(categoryId: section.category.id)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(.orange)
                    Button {
                        presenter.delete(categoryId: section.category.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
                .listRowInsets(.init(top: 16, leading: 8, bottom: 0, trailing: 8))
                .listRowSeparator(.hidden)
                .frame(minHeight: 60, alignment: .leading)
                .background(Color(section.category.color ?? UIColor.white))
                .clipShape(.rect(cornerRadii: section.dishes.isEmpty ?
                                 RectangleCornerRadii(topLeading: 16,
                                                      bottomLeading: 16,
                                                      bottomTrailing: 16,
                                                      topTrailing: 16) :
                                    RectangleCornerRadii(topLeading: 16, topTrailing: 16))
                )
                ForEach(section.dishes) { dish in
                    VStack {
                        HStack {
                            Text(dish.name)
                                .foregroundStyle(Color(UIColor.black))
                                .font(Font.custom("RussoOne", size: 14))
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        HStack {
                            Text("300/150/200 1000")
                                .foregroundStyle(Color(UIColor.lightGray))
                                .font(Font.custom("RussoOne", size: 12))
                            Spacer()
                        }
                    }
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
        }
        .listStyle(.plain)
        .navigationTitle("Dishes")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            presenter.didAppear()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.tapSearch()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem {
                Menu {
                    Button("Create dish", action: presenter.tapNewDish)
                    Button("Create category", action: presenter.tapNewCategory)
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

struct DishesSectionsListPreviews: PreviewProvider {
    
    static var previews: some View {
        ApplicationViewBuilder.stub.build(view: .dishesSectionsList)
    }
}

