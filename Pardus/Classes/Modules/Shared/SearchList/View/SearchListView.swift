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
            TextField("searchview.search.placeholder",
                      text: $viewState.searchText)
                .accessibilityIdentifier("searchlist.searchview")
                .defaultTextField()
            List(viewState.items) { item in
                SubtitleCell(title: item.title,
                             subtitle: item.subtitle,
                             badgeColor: item.categoryColor,
                             accessibilityId: "searchlist.cell.\(item.id)")
                .defaultCellInsets()
                .swipeActions {
                    Button {
                        presenter.delete(entityId: item.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                    Button {
                        presenter.tapEditEntity(entityId: item.id)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(.orange)
                }
            }
            .accessibilityIdentifier("searchlist.list")
            .listStyle(.plain)
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    presenter.tapCategories()
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.icon2)
                        .foregroundStyle(.primaryText)
                }
                Button {
                    presenter.tapNewEntity()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.icon2)
                        .foregroundStyle(.primaryText)
                }
            }
        }
        .navigationTitle(viewState.navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            presenter.didAppear()
        }
    }
}

struct SearchListPreviews: PreviewProvider {
    
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
                viewBuilder.build(view: .dishList)
            }
            
            NavigationStack {
                viewBuilder.build(view: .dishList)
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private static func makeMockData(container: Container) {
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let context = coreDataStackService.getMainQueueContext()
        
        let dishCategory = DishCategory(context: context)
        dishCategory.id = UUID()
        dishCategory.name = "Salads"
        dishCategory.colorHex = "#00AA00"
        
        let dish = Dish(context: context)
        dish.id = UUID()
        dish.name = "Caesar salad"
        dish.category = dishCategory
        
        let ingridient = Ingridient(context: context)
        ingridient.id = UUID()
        ingridient.name = "Chicken"
        dish.ingridients?.insert(ingridient)

        try? context.save()
    }
}

