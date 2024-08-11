//
//  Views+Modifiers.swift
//  Pardus
//
//  Created by Igor Postoev on 11.8.24..
//

import SwiftUI

extension View {
    
    func defaultCellInsets() -> some View {
        modifier(DefaultCellInsets())
    }
}

private struct DefaultCellInsets: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .listRowInsets(.init(top: 4,
                                 leading: 0,
                                 bottom: 4,
                                 trailing: 0))
    }
}
