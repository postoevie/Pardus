//
//  DishEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//
//

import SwiftUI

struct DishEditView<ViewState: DishEditViewStateProtocol,
                    Presenter: DishEditPresenterProtocol>: View {
    
    @StateObject var viewState: ViewState
    @StateObject var presenter: Presenter
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Text("Name")
                    .font(Font.custom("RussoOne", size: 20))
                    .foregroundStyle(Color(UIColor.lightGray))
                Spacer()
                TextField("", text: $viewState.name)
            }
            HStack {
                Text("Category")
                    .font(Font.custom("RussoOne", size: 20))
                    .foregroundStyle(Color(UIColor.lightGray))
                Spacer()
                Button {
                    presenter.editCategoryTapped()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
            if let category = viewState.category {
                HStack {
                    Circle()
                        .frame(width: 16)
                        .foregroundStyle(Color(category.color ?? UIColor.clear))
                    Text(category.name)
                    Spacer()
                }
            }
            HStack {
                Text("Ingridients")
                    .padding(.top)
                Spacer()
                Button {
                    presenter.editIngridientsTapped()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
            .font(Font.custom("RussoOne", size: 20))
            .foregroundStyle(Color(UIColor.lightGray))
            List(viewState.ingridients) { item in
                DishIngredientRow(item: item)
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
        .padding()
        .font(Font.custom("RussoOne", size: 16))
        .foregroundStyle(Color(UIColor.black))
        .textFieldStyle(.roundedBorder)
        .navigationTitle("Dish editing")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.doneTapped()
                } label: {
                    Image(systemName: "externaldrive.badge.checkmark")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

fileprivate struct DishIngredientRow: View {
    
    private let item: DishIngridientsListItem
    
    init(item: DishIngridientsListItem) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            SubtitleCell(title: item.title,
                         subtitle: item.subtitle,
                         color: item.categoryColor ?? .clear)
            .textFieldStyle(.roundedBorder)
            .frame(width: 100)
        }
    }
}

struct DishEditPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        ApplicationViewBuilder(container: RootApp().container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        NavigationStack {
            viewBuilder.build(view: .dishEdit(dishId: makeMockData()))
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
        
        
        let vegs = IngridientCategory(context: context)
        vegs.name = "Vegs"
        vegs.colorHex = "#00AA00"
        
        let carrot = Ingridient(context: context)
        carrot.id = UUID()
        carrot.name = "Carrot"
        carrot.category = vegs
        
        dish.ingridients?.insert(carrot)
        
        try? context.save()
        
        return dish.id
    }
}
