//
//  Image+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/29/25.
//

import Foundation
import SwiftUI

extension Image {
    
    /// 이미지에 아이콘 버튼 스타일 적용
    /// - Parameters:
    ///   - size: 이미지 사이즈, 기본값 = ComponentSize.iconBtnImageSize
    ///   - foregroundColor: 이미지 색상, 기본값 = Color.moneyTogether.label.alternative
    ///   - padding: 이미지 주변에 적용할 패딩, 기본값 = ComponentSize.iconBtnImageSize / 2
    func iconStyle(
        size: CGFloat = ComponentSize.iconBtnImageSize,
        foregroundColor: Color = Color.moneyTogether.label.alternative,
        padding: CGFloat = ComponentSize.iconBtnImageSize / 2) -> some View {
            
        self
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(foregroundColor)
            .scaledToFit()
            .frame(width: size, height: size)
            .padding(padding)
    }
}
