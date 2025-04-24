//
//  View+TextStyle.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/24/25.
//

import SwiftUI

extension View {
    /// 커스텀 폰트 스타일 적용
    /// swiftUI 에서 사용
    /// ex) Text("...").moneyTogether(style: .h1)
    func moneyTogetherFont(style: MoneyTogetherTextStyle) -> some View {
        self.font(style.swiftUIFont)
    }
}
