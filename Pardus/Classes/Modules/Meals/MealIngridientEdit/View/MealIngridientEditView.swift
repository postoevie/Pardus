//
//  IngridientEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

struct MealIngridientEditView<ViewState: MealIngridientEditViewStateProtocol,
                              Presenter: MealIngridientEditPresenterProtocol>: View {
           
    @StateObject var viewState: ViewState
    @StateObject var presenter: Presenter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack {
                    HStack {
                        MealParameterCell(title: "dishparameter.kcal",
                                          value: viewState.calories)
                    }
                    HStack {
                        MealParameterCell(title: "dishparameter.proteins",
                                          value: viewState.proteins)
                        MealParameterCell(title: "dishparameter.fats",
                                          value: viewState.fats)
                        MealParameterCell(title: "dishparameter.carbs",
                                          value: viewState.carbohydrates)
                    }
                }
                FieldSectionView(titleKey: "itemEdit.label.name") {
                    TextField("", text: $viewState.name)
                        .defaultTextField()
                        .onSubmit {
                            presenter.submitValues()
                        }
                }
                FieldSectionView(titleKey: "dishparameter.weight") {
                    TextField("", text: $viewState.weight)
                        .defaultTextField()
                        .onSubmit {
                            presenter.submitValues()
                        }
                }
                FieldSectionView(titleKey: "dishparameter.kcalsper100") {
                    TextField("", text: $viewState.caloriesPer100)
                        .defaultTextField()
                        .onSubmit {
                            presenter.submitValues()
                        }
                }
                FieldSectionView(titleKey: "dishparameter.proteinsper100") {
                    TextField("", text: $viewState.proteinsPer100)
                        .defaultTextField()
                        .onSubmit {
                            presenter.submitValues()
                        }
                }
                FieldSectionView(titleKey: "dishparameter.fatsper100") {
                    TextField("", text: $viewState.fatsPer100)
                        .defaultTextField()
                        .onSubmit {
                            presenter.submitValues()
                        }
                }
                FieldSectionView(titleKey: "dishparameter.carbsper100") {
                    TextField("", text: $viewState.carbsPer100)
                        .defaultTextField()
                        .onSubmit {
                            presenter.submitValues()
                        }
                }
                Spacer()
            }
        }
        .onAppear {
            presenter.didAppear()
        }
        .font(.bodyRegular)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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

struct MealIngridientEditPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        ApplicationViewBuilder(container: RootApp().container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        NavigationStack {
            viewBuilder.build(view: .mealIngridientEdit(ingridientId: makeMockData()))
        }
    }
    
    private static func makeMockData() -> UUID {
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        
        let context = coreDataStackService.getMainQueueContext()
        
        let ingridient = MealIngridient(context: context)
        ingridient.id = UUID()
        ingridient.name = "Potato"
        
        try? context.save()
        
        return ingridient.id
    }
}
