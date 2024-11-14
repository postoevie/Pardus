//
//  MealEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

struct MealDishEditView: View {
    
    @StateObject var viewState: MealDishEditViewState
    @StateObject var presenter: MealDishEditPresenter
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack {
                    Text("kCal")
                    Text(viewState.sumKcals)
                }
                Spacer()
                VStack {
                    Text("Proteins")
                    Text(viewState.sumProteins)
                }
                Spacer()
                VStack {
                    Text("Fats")
                    Text(viewState.sumFats)
                }
                Spacer()
                VStack {
                    Text("Carbs")
                    Text(viewState.sumCarbs)
                }
            }
            HStack {
                Text("Ingridients")
                    .padding(.top)
                Spacer()
                Menu {
                    //Button("Create new", action: presenter.editDishesTapped)
                    Button("Add from catalog") { presenter.editIngridientsTapped() }
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
            .font(Font.custom("RussoOne", size: 20))
            .foregroundStyle(Color(UIColor.lightGray))
            List(viewState.ingridients) { item in
                MealDishIngridientRow(item: item,
                                      onSubmit: {
                    presenter.updateIngridientWeight(ingridientId: item.id, weightString: $0)
                })
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
        .navigationTitle("Meal dish editing")
        .navigationBarTitleDisplayMode(.large)
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

fileprivate struct MealDishIngridientRow: View {

    @State var weight: String
    
    private let item: MealDishesIngridientsListItem
    private let onSubmit: (String) -> Void
    
    init(item: MealDishesIngridientsListItem, onSubmit: @escaping (String) -> Void) {
        self.weight = item.weight
        self.item = item
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        HStack {
            SubtitleCell(title: item.title,
                         subtitle: item.subtitle,
                         color: item.categoryColor ?? .clear)
            TextField("weight",
                      text: $weight)
            .submitLabel(.done)
            .onSubmit {
                onSubmit(weight)
            }
            .textFieldStyle(.roundedBorder)
            .frame(width: 100)
        }
    }
}

struct MealDishEditPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ApplicationViewBuilder.preview.build(view: .mealEdit(mealId: UUID()))
        }
    }
}

