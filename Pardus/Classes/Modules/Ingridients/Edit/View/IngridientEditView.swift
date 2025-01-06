//
//  IngridientEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

struct IngridientEditView<ViewState: IngridientEditViewStateProtocol,
                          Presenter: IngridientEditPresenterProtocol>: View {
           
    @StateObject var viewState: ViewState
    @StateObject var presenter: Presenter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                FieldSectionView(titleKey: "itemEdit.label.name") {
                    TextField("", text: $viewState.name)
                        .defaultTextField()
                }
                FieldSectionView(titleKey: "dishparameter.kcalsper100") {
                    TextField("", text: $viewState.calories)
                        .defaultTextField()
                }
                FieldSectionView(titleKey: "dishparameter.proteinsper100") {
                    TextField("", text: $viewState.proteins)
                        .defaultTextField()
                }
                FieldSectionView(titleKey: "dishparameter.fatsper100") {
                    TextField("", text: $viewState.fats)
                        .defaultTextField()
                }
                FieldSectionView(titleKey: "dishparameter.carbsper100") {
                    TextField("", text: $viewState.carbohydrates)
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
