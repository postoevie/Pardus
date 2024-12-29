//
//  MealEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

struct MealDishEditView<Presenter: MealDishEditPresenterProtocol>: View {
    
    @StateObject var viewState: MealDishEditViewState
    @StateObject var presenter: Presenter
    
    @FocusState var focusedIdemId: UUID?
    
    var body: some View {
        VStack {
            FieldSectionView(titleKey: "itemEdit.label.name") {
                TextField("", text: $viewState.name)
                    .defaultTextField()
                    .onSubmit {
                        presenter.submitValues()
                    }
            }
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
                    Button("mealdishedit.ingridients.button.createNew") {
                        presenter.createIngridientTapped()
                    }
                    Button("mealdishedit.ingridients.button.addfromcatalog") {
                        presenter.addCatalogIngridientsTapped()
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
            List($viewState.ingridients) { $item in
                MealDishIngridientRow(item: $item,
                                      focusedIdemId: $focusedIdemId)
                .defaultCellInsets()
                .swipeActions {
                    Button {
                        presenter.removeIngridientTapped(ingridientId: item.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                    Button {
                        presenter.editIngridientTapped(ingridientId: item.id)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(.orange)
                }
            }
            .listStyle(.plain)
            Spacer()
        }
        .onAppear {
            presenter.didAppear()
        }
        .onChange(of: focusedIdemId) { oldValue, newValue in
            if let oldValue {
                presenter.updateIngridientWeight(ingridientId: oldValue)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    presenter.doneTapped()
                } label: {
                    Text("app.done")
                        .font(.titleRegular)
                        .foregroundStyle(.primaryText)
                }
            }
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button {
                        presenter.submitValues()
                        focusedIdemId = nil
                    } label: {
                        Text("app.done")
                            .font(.keyboard)
                    }
                }
            }
        }
    }
}

fileprivate struct MealDishIngridientRow: View {
    
    private let item: Binding<MealDishesIngridientsListItem>
    private let focusedIdemId: FocusState<UUID?>.Binding
    
    init(item: Binding<MealDishesIngridientsListItem>,
         focusedIdemId: FocusState<UUID?>.Binding) {
        self.item = item
        self.focusedIdemId = focusedIdemId
    }
    
    var body: some View {
        HStack {
            SubtitleCell(title: item.title.wrappedValue,
                         subtitle: item.subtitle.wrappedValue,
                         badgeColor: item.categoryColor.wrappedValue)
            TextField("mealdishedit.ingridients.placeholder.weight",
                      text: item.weight)
            .numericTextField()
            .focused(focusedIdemId, equals: item.id)
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

