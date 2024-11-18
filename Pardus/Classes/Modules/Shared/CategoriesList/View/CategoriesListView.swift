//
//  CategoriesListView.swift
//  Pardus
//
//  Created by Igor Postoev on 23.7.24.
//
//

import SwiftUI

struct CategoriesListView<Presenter: CategoriesListPresenterProtocol>: View {
    
    @StateObject var viewState: CategoriesListViewState
    @StateObject var presenter: Presenter
    
    var body: some View {
        List {
            ForEach(viewState.sections, id: (\.categoryId)) { section in
                Section {
                    SectionHeader(section: section)
                    .clipped(all: section.dishes.isEmpty)
                    .swipeActions {
                        if let categoryId = section.categoryId {
                            Button {
                                presenter.delete(categoryId: categoryId)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                            Button {
                                presenter.tapEdit(categoryId: categoryId)
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .tint(.orange)
                        }
                    }
                    ForEach(section.dishes) { dish in
                        SubtitleCell(title: dish.title,
                                     subtitle: dish.subtitle,
                                     color: .clear)
                        .defaultCellInsets()
                        .swipeActions {
                            Button {
                                presenter.delete(dishId: dish.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                            Button {
                                presenter.tapEditDish(dishId: dish.id)
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
        }
        .listSectionSpacing(16)
        .listStyle(.plain)
        .padding()
        .navigationTitle(viewState.navigationTitle)
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
                    Button("Create item", action: presenter.tapNewDetail)
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

struct CategoriesListPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        let container = RootApp().container
        makeMockData(container: container)
        return ApplicationViewBuilder(container: container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        NavigationStack {
            viewBuilder.build(view: .dishCategoriesList)
        }
    }
    
    private static func makeMockData(container: Container) {
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        
        let context = coreDataStackService.getMainQueueContext()
        
        let dishCategory = DishCategory(context: context)
        dishCategory.name = "Salads"
        dishCategory.colorHex = "#00AA00"
        dishCategory.id = UUID()
        
        let dish = Dish(context: context)
        dish.id = UUID()
        dish.name = "Carrot salad 🥕"
        dish.category = dishCategory
        
        let soup = Dish(context: context)
        soup.id = UUID()
        soup.name = "Soup 🍜"
        soup.category = dishCategory
        
        try? context.save()
    }
}

private struct SectionHeader: View {
    
    let section: CategoriesListSection
    
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
