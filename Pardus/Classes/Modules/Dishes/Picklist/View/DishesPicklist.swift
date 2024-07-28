//
//  DishesPicklist.swift
//  Pardus
//
//  Created by Igor Postoev on 10.6.24.
//  
//

import SwiftUI

struct PicklistView: View {
           
    @StateObject var viewState: PicklistState
    @StateObject var presenter: PicklistPresenter
    
    var body: some View {
        VStack {
            TextField("Name", text: $viewState.searchText)
                .textFieldStyle(.roundedBorder)
            List(viewState.items, id: \.id) { item in
                Button {
                    presenter.setSelected(item: item)
                } label: {
                    HStack {
                        switch item.type {
                        case .onlyTitle(let title, let indicatorColor):
                            OnlyTitleCell(title: title, color: indicatorColor)
                        case .withSubtitle(let title,
                                           let subtitle,
                                           let indicatorColor):
                            SubtitleCell(title: title,
                                         subtitle: subtitle,
                                         color: indicatorColor)
                        }
                        Spacer()
                        if item.isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color(UIColor.green.withAlphaComponent(0.5)))
                        }
                        
                    }
                    .padding(.leading)
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .frame(minHeight: 60)
            }
            
            .listStyle(.plain)
        }
        .navigationTitle("Select option")
        .padding()
        .toolbar {
            ToolbarItem {
                Button {
                    presenter.doneTapped()
                } label: {
                    Text("Save")
                }
            }
        }
        .onAppear {
            presenter.didAppear()
        }
    }
}

struct DishesPickPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ApplicationViewBuilder.preview.build(view: .picklist(callingView: .dishList, preselected: Set(), completion: {_ in }))
        }
    }
}

