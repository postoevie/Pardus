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
        VStack {
            VStack(spacing: 16) {
                VStack (spacing: 8) {
                    HStack {
                        Text("itemEdit.label.name")
                            .font(.bodyLarge)
                            .foregroundStyle(.secondaryText)
                        Spacer()
                    }
                    TextField("", text: $viewState.name)
                        .defaultTextField()
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("dishedit.label.category")
                            .font(.bodyLarge)
                            .foregroundStyle(.secondaryText)
                        Spacer()
                        Button {
                            presenter.editCategoryTapped()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.icon)
                                .foregroundStyle(.primaryText)
                        }
                        Spacer()
                            .frame(width: Styles.listActionPadding)
                    }
                    if let category = viewState.category {
                        HStack {
                            Text(category.name)
                            Circle()
                                .frame(width: Styles.listBadgeSize)
                                .foregroundStyle(category.color)
                            Spacer()
                        }
                    }
                }
                HStack {
                    Text("dishedit.ingridients.label")
                        .padding(.top)
                    Spacer()
                    Button {
                        presenter.editIngridientsTapped()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.icon)
                            .foregroundStyle(.primaryText)
                    }
                    Spacer()
                        .frame(width: Styles.listActionPadding)
                }
                .font(.bodyLarge)
                .foregroundStyle(.secondaryText)
                List(viewState.ingridients) { item in
                    SubtitleCell(title: item.title,
                                 subtitle: item.subtitle,
                                 badgeColor: item.categoryColor)
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
            .font(.bodyRegular)
            .navigationTitle("dishedit.navigation.title")
            .navigationBarTitleDisplayMode(.inline)
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
            }
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
        
        dish.ingridients.insert(carrot)
        
        try? context.save()
        
        return dish.id
    }
}
