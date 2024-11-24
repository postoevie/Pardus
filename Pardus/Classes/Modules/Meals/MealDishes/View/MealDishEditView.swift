//
//  MealEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

struct MealDishEditView<ViewState: MealDishEditViewStateProtocol, Presenter: MealDishEditPresenterProtocol>: View {
    
    @StateObject var viewState: ViewState
    @StateObject var presenter: Presenter
    
    var body: some View {
        VStack {
            HStack {
                MealParameterCell(title: "dishparameter.kcal",
                                  value: viewState.sumKcals)
                MealParameterCell(title: "dishparameter.weight",
                                  value: viewState.weight)
            }
            HStack {
                MealParameterCell(title: "dishparameter.proteins",
                                  value: viewState.sumProteins)
                MealParameterCell(title: "dishparameter.fats",
                                  value: viewState.sumFats)
                MealParameterCell(title: "dishparameter.carbs",
                                  value: viewState.sumCarbs)
            }
            HStack {
                Text("mealdishedit.ingridients.title")
                Spacer()
                Menu {
                    //Button("Create new", action: presenter.editDishesTapped)
                    Button("mealdishedit.ingridients.button.addfromcatalog") { presenter.editIngridientsTapped()
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.icon)
                        .foregroundStyle(.primaryText)
                }
                Spacer()
                    .frame(width: Styles.listActionPadding)
            }
            .padding(.top)
            .font(.bodyLarge)
            .foregroundStyle(.secondaryText)
            List(viewState.ingridients) { item in
                MealDishIngridientRow(item: item,
                                      onSubmit: {
                    presenter.updateIngridientWeight(ingridientId: item.id, weightString: $0)
                })
                .defaultCellInsets()
                .swipeActions {
                    Button {
                        presenter.remove(ingridientId: item.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
            .listStyle(.plain)
            Spacer()
        }
        .onAppear {
            presenter.didAppear()
        }
        .navigationTitle(viewState.navigationTitle)
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
    }
}

fileprivate struct MealDishIngridientRow: View {

    @State var weight: String
    
    private let item: MealDishesIngridientsListItem
    private let onSubmit: (String) -> Void
    
    init(item: MealDishesIngridientsListItem, onSubmit: @escaping (String) -> Void) {
        self.weight = item.weight
        self.item = item
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        HStack {
            SubtitleCell(title: item.title,
                         subtitle: item.subtitle,
                         badgeColor: item.categoryColor)
            TextField("mealdishedit.ingridients.placeholder.weight",
                      text: $weight)
            .defaultTextField()
            .onSubmit {
                onSubmit(weight)
            }
            .frame(width: 100)
        }
    }
}

struct MealDishEditPreviews: PreviewProvider {
    
    static var mealDishId: UUID?
    
    static let viewBuilder: ApplicationViewBuilder = {
        let container = RootApp().container
        mealDishId = makeMockData(container)
        return ApplicationViewBuilder(container: container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        NavigationStack {
            viewBuilder.build(view: .mealDishEdit(mealDishId: mealDishId))
        }
    }
    
    private static func makeMockData(_ container: Container) -> UUID {
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        
        let context = coreDataStackService.getMainQueueContext()

        let dish = Dish(context: context)
        dish.id = UUID()
        dish.name = "Carrot salad 🥕"
        
        let meal = Meal(context: context)
        meal.id = UUID()
        meal.date = Date()
    
        let mealDish = MealDish(context: context)
        mealDish.id = UUID()
        mealDish.meal = meal
        mealDish.dish = dish
        
        let carrot = Ingridient(context: context)
        carrot.id = UUID()
        carrot.name = "Carrot"
        carrot.calories = 50
        dish.ingridients?.insert(carrot)
        
        let carrotInMeal = MealIngridient(context: context)
        carrotInMeal.id = UUID()
        carrotInMeal.ingridient = carrot
        carrotInMeal.dish = mealDish
        carrotInMeal.weight = 200
        
        try? context.save()
        
        return mealDish.id
    }
}

