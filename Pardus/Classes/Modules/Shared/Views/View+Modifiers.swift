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
            .listRowInsets(.init(top: 8,
                                 leading: 0,
                                 bottom: 8,
                                 trailing: 0))
    }
}
