//
//  CTAButtonStyle.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/6/25.
//

import Foundation


enum ButtonStyleType {
    case solid
    case ghost
}

enum ButtonState {
    case active
    case inactive
}


// MARK: ButtonStyle For SwiftUI CTAButton

import SwiftUI

/// CTAButton 에서 사용하는 Custom ButtonStyle
struct CTAButtonStyle: ButtonStyle {
    var style: ButtonStyleType
    var state: ButtonState
    var cornerRadius: CGFloat
    
    init(style: ButtonStyleType = .solid,
         state: ButtonState = .active,
         cornerRadius: CGFloat = Radius.small) {
        self.style = style
        self.state = state
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        switch (style, state) {
        case (.solid, .active):
            configureActiveSolidStyle(config: configuration)
        case (.solid, .inactive):
            configureInactiveSolidStyle(config: configuration)
        case (.ghost, .active):
            configureActiveGhostStyle(config: configuration)
        case (.ghost, .inactive):
            configureInactiveSolidStyle(config: configuration)
        }
    }
}


// MARK: Configure Functions

extension CTAButtonStyle {
    private func configureActiveSolidStyle(config: Configuration) -> some View {
        config.label
            .foregroundColor(.moneyTogether.label.rNormal)
            .background(Color.moneyTogether.brand.primary)
            .cornerRadius(cornerRadius)
    }
    
    private func configureActiveGhostStyle(config: Configuration) -> some View {
        config.label
            .foregroundColor(.moneyTogether.brand.primary)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.moneyTogether.brand.primary, lineWidth: 1)
            )
    }
    
    private func configureInactiveSolidStyle(config: Configuration) -> some View {
        config.label
            .foregroundColor(.moneyTogether.label.inactive)
            .background(Color.moneyTogether.grayScale.baseGray20)
            .cornerRadius(cornerRadius)
    }
    
    private func configureInactiveGhostStyle(config: Configuration) -> some View {
        config.label
            .foregroundColor(.moneyTogether.label.inactive)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.moneyTogether.system.inactive, lineWidth: 1)
            )
    }
    
    
}
