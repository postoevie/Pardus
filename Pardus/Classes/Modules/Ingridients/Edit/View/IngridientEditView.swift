//
//  IngridientEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

struct IngridientEditView: View {
           
    @StateObject var viewState: IngridientEditViewState
    @StateObject var presenter: IngridientEditPresenter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Text("ingridientedit.label.name")
                        .font(.bodyLarge)
                        .foregroundStyle(.secondaryText)
                    Spacer()
                    TextField("", text: $viewState.name)
                }
                VStack(spacing: 8) {
                    HStack(spacing: 16) {
                        Text("ingridientedit.label.category")
                            .font(.bodyLarge)
                            .foregroundStyle(.secondaryText)
                        Spacer()
                        Button {
                            presenter.tapEditCategory()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.title2)
                                .foregroundStyle(.primaryText)
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
                        TextField("", value: $viewState.calories, formatter: .nutrients)
                    }
                    FieldSectionView(title: "Proteins per 100 grams") {
                        TextField("", value: $viewState.proteins, formatter: .nutrients)
                    }
                    FieldSectionView(title: "Fats per 100 grams") {
                        TextField("", value: $viewState.fats, formatter: .nutrients)
                    }
                    FieldSectionView(title: "Carbohydrates per 100 grams") {
                        TextField("", value: $viewState.carbohydrates, formatter: .nutrients)
                    }
                }.submitLabel(.done)
                Spacer()
            }
        }
        .padding()
        .onAppear {
            presenter.didAppear()
        }
        .font(.bodyRegular)
        .textFieldStyle(.roundedBorder)
        .navigationTitle("ingridientedit.navigation.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.doneTapped()
                } label: {
                    Image(systemName: "externaldrive.badge.checkmark")
                        .font(.title2)
                        .foregroundStyle(.primaryText)
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
                    .font(.bodyLarge)
                    .foregroundStyle(.secondaryText)
                Spacer()
            }
            content()
        }
    }
}

struct IngridientEditPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        ApplicationViewBuilder(container: RootApp().container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        NavigationStack {
            viewBuilder.build(view: .ingridientEdit(ingridientId: makeMockData()))
        }
    }
    
    private static func makeMockData() -> UUID {
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        
        let context = coreDataStackService.getMainQueueContext()
        
        let category = IngridientCategory(context: context)
        category.name = "Vegs"
        category.colorHex = "#00AA00"
        category.id = UUID()
        
        let ingridient = Ingridient(context: context)
        ingridient.id = UUID()
        ingridient.name = "Potato"
        ingridient.category = category
        
        try? context.save()
        
        return ingridient.id
    }
}
