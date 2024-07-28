//
//  OnlyTitleCell.swift
//  Pardus
//
//  Created by Igor Postoev on 25.7.24..
//

import SwiftUI

struct OnlyTitleCell: View {
    
    let title: String
    let color: UIColor
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundStyle(Color(UIColor.black))
                    .font(Font.custom("RussoOne", size: 14))
                Circle()
                    .frame(width: 16)
                    .foregroundStyle(Color(color))
                Spacer()
            }
        }
    }
}


