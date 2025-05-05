//
//  CTAButton.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/4/25.
//

import Foundation
import SwiftUI

/// SwiftUI 에서 사용할 CTA Button
struct CTAButton: View {
    var title: String
    var style: ButtonStyleType
    var state: ButtonState
    var action: (() -> Void)?
    var cornerRadius: CGFloat
    var buttonHeight: CGFloat
    var buttonWidth: CGFloat
    
    init(activeState: ButtonState,
         buttonStyle: ButtonStyleType,
         labelText: String,
         buttonHeight: CGFloat = ComponentSize.ctaBtnHeight,
         buttonWidth: CGFloat = UIScreen.main.bounds.width - (Layout.side),
         cornerRadius: CGFloat = Radius.small,
         action: (() -> Void)?) {
        self.title = labelText
        self.style = buttonStyle
        self.state = activeState
        self.action = action
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Button(
            action: action ?? { fatalError("CTA button action should be implemented") }
        ) {
            Text(title)
                .frame(width: buttonWidth, height: buttonHeight)
        }.buttonStyle(CTAButtonStyle(style: style, state: state, cornerRadius: cornerRadius))
    }
}

