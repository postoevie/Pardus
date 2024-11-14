//
//  DishEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//
//

import SwiftUI

struct DishEditView: View {
    
    @StateObject var viewState: DishEditViewState
    @StateObject var presenter: DishEditPresenter
    
    var body: some View {
        VStack(spacing: 20) {
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
    static var previews: some View {
        NavigationStack {
            ApplicationViewBuilder.preview.build(view: .dishEdit(dishId: nil))
        }
    }
}
