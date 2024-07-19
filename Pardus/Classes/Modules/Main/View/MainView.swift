//
//  MainView.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import SwiftUI

struct MainView: View {
           
    @StateObject var viewState: MainViewState
    @StateObject var presenter: MainPresenter
    
    var body: some View {
        Spacer()
            .onAppear {
                presenter.didAppear()
            }
    }
}

struct MainPreviews: PreviewProvider {
    static var previews: some View {
        ApplicationViewBuilder.stub.build(view: .main)
    }
}

