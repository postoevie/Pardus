//
//  DishCategoryEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//
//

import SwiftUI

struct CategoryEditView<ViewState: CategoryEditViewStateProtocol,
                        Presenter: CategoryEditPresenterProtocol>: View {
    
    @StateObject var viewState: ViewState
    @StateObject var presenter: Presenter
    
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
        .navigationBarTitleDisplayMode(.inline)
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

struct CategoryEditPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        ApplicationViewBuilder(container: RootApp().container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        viewBuilder.build(view: .dishCategoryEdit(dishCategoryId: makeMockData()))
    }
    
    private static func makeMockData() -> UUID {
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let context = coreDataStackService.getMainQueueContext()
        
        let dishCategory = DishCategory(context: context)
        dishCategory.name = "Salads"
        dishCategory.colorHex = "#00AA00"
        dishCategory.id = UUID()
        
        try? context.save()
        
        return dishCategory.id
    }
}
