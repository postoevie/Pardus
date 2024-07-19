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
        VStack {
            TextField("name", text: $viewState.name)
            Spacer()
        }
        .padding(8)
        .onAppear {
            presenter.didAppear()
        }
        .navigationTitle("Dish editing")
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.doneTapped()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct DishEditPreviews: PreviewProvider {
    static var previews: some View {
        ApplicationViewBuilder.stub.build(view: .dishEdit(dishId: nil))
    }
}

