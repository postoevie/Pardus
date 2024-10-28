//
//  MealEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

struct MealEditView: View {
    
    @StateObject var viewState: MealEditViewState
    @StateObject var presenter: MealEditPresenter
    
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
            Group {
                DatePicker(
                    "Date",
                    selection: $viewState.date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                HStack {
                    Text("Dishes")
                        .padding(.top)
                    Spacer()
                    Button {
                        presenter.editDishesTapped()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                            .foregroundStyle(.black)
                    }
                    
                }
            }
            .font(Font.custom("RussoOne", size: 20))
            .foregroundStyle(Color(UIColor.lightGray))
            List(viewState.dishItems) { item in
                MealDishRow(item: item,
                            onSubmit: {
                    presenter.updateDishMealWeight(mealDishId: item.id, weightString: $0)
                })
                .swipeActions {
                    Button {
                        presenter.remove(dishId: item.id)
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
        .navigationTitle("Meal editing")
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

struct MealDishRow: View {

    @State var weight: String
    
    private let item: MealDishesListItem
    private let onSubmit: (String) -> Void
    
    init(item: MealDishesListItem, onSubmit: @escaping (String) -> Void) {
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

struct MealEditPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ApplicationViewBuilder.preview.build(view: .mealEdit(mealId: UUID()))
        }
    }
}

