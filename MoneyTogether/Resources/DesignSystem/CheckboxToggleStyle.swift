//
//  CheckboxToggleStyle.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/26/25.
//

import Foundation
import SwiftUI

extension ToggleStyle where Self == CheckboxToggleStyle {
    static var customCheckbox: CheckboxToggleStyle { .init() }
}

struct CheckboxToggleStyle: ToggleStyle {
    @State private var checkboxImageName: String = "circle"
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Image(checkboxImageName)
                .iconStyle(size: 24, foregroundColor: .moneyTogether.brand.primary, padding: 8)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        configuration.isOn.toggle()
                        self.checkboxImageName = configuration.isOn ? "check_circle_fill" : "circle"
                    }
                }
        }
    }
}
