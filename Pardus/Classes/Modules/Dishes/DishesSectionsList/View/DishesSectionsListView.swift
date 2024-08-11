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
            ForEach(viewState.sections, id: (\.categoryId)) { section in
                Section {
                    SectionHeader(section: section)
                    .clipped(all: section.dishes.isEmpty)
                    .swipeActions {
                        if let categoryId = section.categoryId {
                            Button {
                                presenter.tapEdit(categoryId: categoryId)
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .tint(.orange)
                            Button {
                                presenter.delete(categoryId: categoryId)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    ForEach(section.dishes) { dish in
                        SubtitleCell(title: dish.name,
                                     subtitle: "300/150/200 1000",
                                     color: .clear)
                        .defaultCellInsets()
                        .padding(8)
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
        }
        .listSectionSpacing(16)
        .listStyle(.plain)
        .padding(8)
        .navigationTitle("Dishes")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            presenter.didAppear()
        }
        .alert(viewState.alertTitle,
               isPresented: $viewState.alertPresented,
               actions: {
            Button("OK") {
                presenter.okAlertTapped()
            }
        })
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
        NavigationStack {
            ApplicationViewBuilder.preview.build(view: .dishesSectionsList)
        }
    }
}

private struct SectionHeader: View {
    
    let section: DishListSection
    
    var body: some View {
        HStack {
            Spacer()
            Text(section.title)
                .foregroundStyle(Color(UIColor.white))
                .font(Font.custom("RussoOne", size: 24))
            Spacer()
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
        .frame(minHeight: 60, alignment: .leading)
        .background(Color(section.color ?? UIColor.clear))
    }
}

private extension View {
    
    func clipped(all: Bool) -> some View {
        modifier(ClipSide(clipAll: all))
    }
}

private struct ClipSide: ViewModifier {
    
    let clipAll: Bool
    
    func body(content: Content) -> some View {
        content
            .clipShape(.rect(cornerRadii: clipAll ?
                             RectangleCornerRadii(topLeading: 16,
                                                  bottomLeading: 16,
                                                  bottomTrailing: 16,
                                                  topTrailing: 16):
                             RectangleCornerRadii(topLeading: 16, topTrailing: 16))
            )
    }
}
