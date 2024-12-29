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
                    .clipped(all: section.items.isEmpty)
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
                    ForEach(section.items) { item in
                        SubtitleCell(title: item.title,
                                     subtitle: item.subtitle,
                                     badgeColor: .clear)
                        .defaultCellInsets()
                        .swipeActions {
                            Button {
                                presenter.delete(dishId: item.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                            Button {
                                presenter.tapEditDish(dishId: item.id)
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
        .navigationTitle(viewState.navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            presenter.didAppear()
        }
        .alert(viewState.alertTitle,
               isPresented: $viewState.alertPresented,
               actions: {
            Button("app.ok") {
                presenter.okAlertTapped()
            }
        })
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.tapSearch()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.icon2)
                        .foregroundStyle(.primaryText)
                }
            }
            ToolbarItem {
                Menu {
                    Button("categorieslist.button.createitem", action: presenter.tapNewDetail)
                    Button("categorieslist.button.createcategory", action: presenter.tapNewCategory)
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.icon2)
                        .foregroundStyle(.primaryText)
                }
            }
        }
    }
}

private struct SectionHeader: View {
    
    let section: CategoriesListSection
    
    var body: some View {
        HStack {
            Spacer()
            Text(section.title)
                .foregroundStyle(Color(UIColor.white))
                .font(.bodyLarge)
            Spacer()
        }
        .listRowInsets(.init(top: 0,
                             leading: 0,
                             bottom: 0,
                             trailing: 0))
        .listRowSeparator(.hidden)
        .frame(minHeight: 60, alignment: .leading)
        .background(section.color)
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
        Group {
            NavigationStack {
                viewBuilder.build(view: .dishCategoriesList)
            }
            
            NavigationStack {
                viewBuilder.build(view: .dishCategoriesList)
            }
            .preferredColorScheme(.dark)
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
