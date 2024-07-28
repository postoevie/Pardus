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
            FieldSectionView(title: "Name") {
                TextField("", text: $viewState.name)
            }
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    Text("Category")
                        .font(Font.custom("RussoOne", size: 20))
                        .foregroundStyle(Color(UIColor.lightGray))
                    Button {
                        presenter.tapEditCategory()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                            .foregroundStyle(.black)
                    }
                    Spacer()
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
            FieldSectionView(title: "Calories in 0.1L") {
                TextField("", text: $viewState.kcalsPer100)
                    .disabled(true)
            }
            FieldSectionView(title: "Description") {
                TextField("", text: $viewState.dishDescription)
                    .disabled(true)
            }
            Spacer()
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
