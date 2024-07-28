//
//  MealsListView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

struct MealsListView: View {
    
    @StateObject var viewState: MealsListViewState
    @StateObject var presenter: MealsListPresenter
    
    var body: some View {
        VStack {
            if viewState.dateSelectionVisible {
                HStack {
                    VStack {
                        DatePicker("StartDate", selection: $viewState.startDate)
                        DatePicker("EndDate", selection: $viewState.endDate)
                    }
                }
                .font(Font.custom("RussoOne", size: 16))
                .foregroundStyle(Color(UIColor.lightGray))
            }
            List(viewState.sections, id: \.title) { section in
                Section {
                    ForEach(section.items) { item in
                        Button {
                            presenter.tapItem(uid: item.id)
                        } label: {
                            SubtitleCell(title: item.title,
                                         subtitle: item.subtitle,
                                         color: .clear)
                        }
                        .listRowInsets(.init(top: 8,
                                             leading: 0,
                                             bottom: 0,
                                             trailing: 0))
                        .buttonStyle(CustomButtonStyle())
                        .listRowSeparator(.hidden)
                        .swipeActions {
                            Button {
                                presenter.deleteitem(uid: item.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                } header: {
                    VStack {
                        Text(section.title)
                            .foregroundStyle(Color(UIColor.lightGray))
                            .font(Font.custom("RussoOne", size: 16))
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        .padding(8)
        .navigationTitle("Meals")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup {
                Button {
                    presenter.tapToggleDateFilter()
                } label: {
                    Image(systemName: viewState.dateSelectionVisible ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
                Button {
                    presenter.tapAddNewItem()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            presenter.didAppear()
        }
    }
    
    static var previews: some View {
        NavigationStack {
            ApplicationViewBuilder.preview.build(view: .mealsList)
        }
    }
}

private struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(UIColor.green.withAlphaComponent(0.2)))
            .foregroundColor(.white)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
