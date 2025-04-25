//
//  UIFont+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/24/25.
//

import UIKit

extension UIFont {
    /// 커스텀 스타일을 적용한 폰트 리턴
    /// uikit 에서 사용
    /// ex) label.font = .moneyTogetherFont(style: .h1)
    static func moneyTogetherFont(style: MoneyTogetherTextStyle) -> UIFont {
        return style.uikitFont
    }
}
