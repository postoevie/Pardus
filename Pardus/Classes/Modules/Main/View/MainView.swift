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
    
    var body: some View {
        Text("Hello iOS")
    }
}

struct MainPreviews: PreviewProvider {
    static var previews: some View {
        ApplicationViewBuilder.stub.build(view: .main)
    }
}

