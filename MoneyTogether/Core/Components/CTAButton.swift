//
//  CTAButton.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/4/25.
//

import Foundation
import SwiftUI

/// SwiftUI 에서 사용할 CTA Button
extension View {
    func CTAButton(activeState state: ButtonState,
                   buttonStyle style: ButtonStyleType,
                   labelText title: String,
                   labelFontStyle: MoneyTogetherTextStyle = .h6,
                   buttonHeight: CGFloat = ComponentSize.ctaBtnHeight,
                   buttonWidth: CGFloat = UIScreen.main.bounds.width - (Layout.side * 2),
                   cornerRadius: CGFloat = Radius.small,
                   action: (() -> Void)?) -> some View {
        Button(
            action: action ?? { fatalError("CTA button action should be implemented") }
        ) {
            Text(title)
                .frame(width: buttonWidth, height: buttonHeight)
                .moneyTogetherFont(style: labelFontStyle)
        }.buttonStyle(CTAButtonStyle(style: style, state: state, cornerRadius: cornerRadius))
    }
}

