//
//  DishCategoryEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//
//

import SwiftUI

struct CategoryEditView: View {
    
    @StateObject var viewState: CategoryEditViewState
    @StateObject var presenter: CategoryEditPresenter
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                TextField(text: $viewState.name,
                          axis: .horizontal,
                          label: {
                    Text("Name")
                })
                .textFieldStyle(.roundedBorder)
            }
            HStack {
                ColorPicker(selection: $viewState.color, label: {
                    Text("Color")
                        .foregroundStyle(Color(UIColor.systemGray3))
                })
            }
            Spacer()
        }
        .padding(16)
        .font(Font.custom("RussoOne", size: 20))
        .foregroundStyle(Color(UIColor.black))
        .navigationTitle("Category edit")
        .onAppear {
            presenter.onAppear()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.tapSave()
                } label: {
                    Image(systemName: "externaldrive.badge.checkmark")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

struct DishCategoryEditPreviews: PreviewProvider {
    
    static var previews: some View {
        ApplicationViewBuilder.preview.build(view: .dishCategoryEdit(dishCategoryId: nil))
    }
}
