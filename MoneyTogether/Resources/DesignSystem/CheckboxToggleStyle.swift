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
    func makeBody(configuration: Configuration) -> some View {
        // Return a view that has checklist appearance and behavior.
        Image(configuration.isOn ? "check_circle_fill" : "circle")
            .iconStyle(size: 24, foregroundColor: .moneyTogether.brand.primary, padding: 8)
            .onTapGesture {
                configuration.isOn.toggle()
            }
            .animation(.bouncy, value: configuration.isOn)
    }
}
