//
//  SubtitleCell.swift
//  Pardus
//
//  Created by Igor Postoev on 25.7.24..
//

import SwiftUI

struct SubtitleCell: View {
    
    let title: String
    let subtitle: String
    let color: UIColor
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundStyle(.primaryText)
                    .font(.bodySmall)
                Circle()
                    .frame(width: 16)
                    .foregroundStyle(Color(color))
                Spacer()
            }
            Spacer()
                .frame(height: 10)
            HStack {
                Text(subtitle)
                    .foregroundStyle(.secondaryText)
                    .font(.bodySmall2)
                Spacer()
            }
        }
    }
}

