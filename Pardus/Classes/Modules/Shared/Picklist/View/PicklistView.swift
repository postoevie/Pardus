//
//  DishesPicklist.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import SwiftUI

struct PicklistView: View {
           
    @StateObject var viewState: PicklistState
    @StateObject var presenter: PicklistPresenter
    
    var body: some View {
        VStack {
            TextField("picklistview.search.placeholder", text: $viewState.searchText)
                .defaultTextField()
            List(viewState.items, id: \.id) { item in
                Button {
                    presenter.setSelected(item: item)
                } label: {
                    HStack {
                        switch item.type {
                        case .onlyTitle(let title, let badgeColor):
                            OnlyTitleCell(title: title, color: badgeColor)
                        case .withSubtitle(let title,
                                           let subtitle,
                                           let badgeColor):
                            SubtitleCell(title: title,
                                         subtitle: subtitle,
                                         badgeColor: badgeColor)
                        }
                        Spacer()
                        if item.isSelected {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.picklistCheckmark)
                        }
                        
                    }
                }
                .listRowInsets(.init(top: 0,
                                     leading: 0,
                                     bottom: 0,
                                     trailing: 0))
                .frame(minHeight: 60)
            }
            
            .listStyle(.plain)
        }
        .navigationTitle("picklistview.navigation.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.doneTapped()
                } label: {
                    Image(systemName: "externaldrive.badge.checkmark")
                        .font(.icon2)
                        .foregroundStyle(.primaryText)
                }
            }
        }
        .onAppear {
            presenter.didAppear()
        }
    }
}

struct DishesPickPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        ApplicationViewBuilder(container: RootApp().container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        NavigationStack {
            viewBuilder.build(view: .dishPicklist(callingView: .mealEdit(mealId: makeMockData()),
                                                                     type: .singular,
                                                                     filter: nil,
                                                                     completion: { _ in }))
        }
    }
    
    private static func makeMockData() -> UUID {
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
        
        let meal = Meal(context: context)
        meal.id = UUID()
        meal.date = Date()
        meal.dishes = Set()
        
        try? context.save()
        
        return meal.id
    }
}

