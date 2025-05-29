//
//  Image+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/29/25.
//

import Foundation
import SwiftUI

extension Image {
    func iconStyle(
        size: CGFloat = 24,
        foregroundColor: Color = Color.moneyTogether.label.alternative,
        padding: CGFloat = 12) -> some View {
            
        self
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(foregroundColor)
            .scaledToFit()
            .frame(width: size, height: size)
            .padding(padding)
    }
}
