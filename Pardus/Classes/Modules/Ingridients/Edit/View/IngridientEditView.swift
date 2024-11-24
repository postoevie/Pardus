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
        VStack {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    HStack {
                        Text("ingridientedit.label.name")
                            .font(.bodyLarge)
                            .foregroundStyle(.secondaryText)
                        Spacer()
                    }
                    TextField("", text: $viewState.name)
                        .defaultTextField()
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("ingridientedit.label.category")
                            .font(.bodyLarge)
                            .foregroundStyle(.secondaryText)
                        Spacer()
                        Button {
                            presenter.tapEditCategory()
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
                FieldSectionView(titleKey: "dishparameter.kcalsper100") {
                    TextField("", value: $viewState.calories,
                              formatter: .nutrients)
                        .defaultTextField()
                }
                FieldSectionView(titleKey: "dishparameter.proteinsper100") {
                    TextField("", value: $viewState.proteins,
                              formatter: .nutrients)
                        .defaultTextField()
                }
                FieldSectionView(titleKey: "dishparameter.fatsper100") {
                    TextField("", value: $viewState.fats,
                              formatter: .nutrients)
                        .defaultTextField()
                }
                FieldSectionView(titleKey: "dishparameter.carbsper100") {
                    TextField("", value: $viewState.carbohydrates, formatter: .nutrients)
                        .defaultTextField()
                }
                Spacer()
            }
        }
        .onAppear {
            presenter.didAppear()
        }
        .font(.bodyRegular)
        .navigationTitle("ingridientedit.navigation.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.doneTapped()
                } label: {
                    Image(systemName: "externaldrive.badge.checkmark")
                        .font(.icon2)
                        .foregroundStyle(.primaryText)
                }
            }
        }
    }
}

private struct FieldSectionView<Content: View>: View {
    
    var titleKey: LocalizedStringKey
    @ViewBuilder var content: () -> Content
    
    init(titleKey: String, content: @escaping () -> Content) {
        self.titleKey = LocalizedStringKey(titleKey)
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(titleKey)
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
