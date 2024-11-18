//
//  MealsListView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

struct MealsListView<ViewState: MealsListViewStateProtocol,
                     Presenter: MealsListPresenterProtocol>: View {
    
    @StateObject var viewState: ViewState
    @StateObject var presenter: Presenter
    
    var body: some View {
        VStack {
            if viewState.dateSelectionVisible {
                HStack {
                    VStack {
                        DatePicker("StartDate", selection: $viewState.startDate)
                        DatePicker("EndDate", selection: $viewState.endDate)
                    }
                }
                .font(Font.custom("RussoOne", size: 16))
                .foregroundStyle(Color(UIColor.lightGray))
            }
            List(viewState.sections, id: \.title) { section in
                Section {
                    ForEach(section.items) { item in
                        Button {
                            presenter.tapItem(uid: item.id)
                        } label: {
                            SubtitleCell(title: item.title,
                                         subtitle: item.subtitle,
                                         color: .clear)
                        }
                        .listRowInsets(.init(top: 0,
                                             leading: 0,
                                             bottom: 0,
                                             trailing: 0))
                        .buttonStyle(CustomButtonStyle())
                        .listRowSeparator(.hidden)
                        .swipeActions {
                            Button {
                                presenter.deleteItem(uid: item.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                } header: {
                    VStack {
                        Text(section.title)
                            .foregroundStyle(Color(UIColor.lightGray))
                            .font(Font.custom("RussoOne", size: 16))
                    }
                    .defaultCellInsets()
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        .padding()
        .navigationTitle("Meals")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup {
                Button {
                    presenter.tapToggleDateFilter()
                } label: {
                    Image(systemName: viewState.dateSelectionVisible ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
                Button {
                    presenter.tapAddNewItem()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            presenter.didAppear()
        }
    }
}

private struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(Color(UIColor.green.withAlphaComponent(0.2)))
            .cornerRadius(8)
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct MealsListPreviews: PreviewProvider {
    
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
            viewBuilder.build(view: .mealsList)
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
        
        let meal = Meal(context: context)
        meal.id = UUID()
        meal.date = Date()
        meal.dishes = Set()
    
        let mealDish = MealDish(context: context)
        mealDish.id = UUID()
        
        let soupMealDish = MealDish(context: context)
        soupMealDish.id = UUID()
        
        mealDish.meal = meal
        mealDish.dish = dish
        
        soupMealDish.meal = meal
        soupMealDish.dish = soup
        
        try? context.save()
    }
}
