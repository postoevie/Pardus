//
//  MealParameterCell.swift
//  Pardus
//
//  Created by Igor Postoev on 18.11.24..
//

import SwiftUI

struct MealParameterCell: View {
    
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .lineLimit(1)
                .font(Font.custom("RussoOne", size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value)
                .lineLimit(1)
                .font(Font.custom("RussoOne", size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(.green)
        .foregroundStyle(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
