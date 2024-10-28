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
        ScrollView {
            VStack(spacing: 20) {
                FieldSectionView(title: "Name") {
                    TextField("", text: $viewState.name)
                }
                VStack(spacing: 8) {
                    HStack(spacing: 16) {
                        Text("Category")
                            .font(Font.custom("RussoOne", size: 20))
                            .foregroundStyle(Color(UIColor.lightGray))
                        Spacer()
                        Button {
                            presenter.tapEditCategory()
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
                }
                Group {
                    FieldSectionView(title: "Kilocalories per 100 grams") {
                        TextField("", value: $viewState.calories, formatter: .dishNumbers)
                    }
                    FieldSectionView(title: "Proteins per 100 grams") {
                        TextField("", value: $viewState.proteins, formatter: .dishNumbers)
                    }
                    FieldSectionView(title: "Fats per 100 grams") {
                        TextField("", value: $viewState.fats, formatter: .dishNumbers)
                    }
                    FieldSectionView(title: "Carbohydrates per 100 grams") {
                        TextField("", value: $viewState.carbohydrates, formatter: .dishNumbers)
                    }
                }.submitLabel(.done)
                Spacer()
            }
        }
        .padding(8)
        .onAppear {
            presenter.didAppear()
        }
        .padding(16)
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

private struct FieldSectionView<Content: View>: View {
    
    var title: String
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text(title)
                    .font(Font.custom("RussoOne", size: 20))
                    .foregroundStyle(Color(UIColor.lightGray))
                Spacer()
            }
            content()
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
