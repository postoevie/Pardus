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
                SubtitleCell(title: item.name,
                             subtitle: "200/200/200",
                             color: item.categoryColor ?? .clear)
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

struct MealEditPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ApplicationViewBuilder.preview.build(view: .mealEdit(mealId: UUID()))
        }
    }
}

