//
//  CardStyle.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/4/25.
//

import Foundation
import SwiftUI

/// 카드 형태의 공통 UI 스타일을 적용하는 ViewModifier
/// - 구성 요소:
///     - 좌우/상하 패딩
///     - 배경색
///     - 모서리 라운드
///     - 그림자
/// - SwiftUI View 에 적용 가능
struct CardContainer: ViewModifier {
    /// 수평 패딩 값
    let horizontalPadding : CGFloat
    /// 수직 패딩 값
    let verticalPadding : CGFloat
    /// 모서리 radius
    let cornerRadius: CGFloat
    /// 배경 색상
    let backgroundColor: Color?
    
    /// init
    /// - Parameters:
    ///   - horizontalPadding: 수평 패딩 값, default = Layout.side
    ///   - verticalPadding: 수직 패딩 값, default = 12
    ///   - cornerRadius: 모서리 radius, default = Radius.large
    ///   - backgroundColor: 배경 색상, default = Color.moneyTogether.background
    init(horizontalPadding: CGFloat = Layout.side,
         verticalPadding: CGFloat = 12,
         cornerRadius: CGFloat = Radius.large,
         backgroundColor: Color? = Color.moneyTogether.background) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: .moneyTogether.grayScale.baseGray30,
                radius: 5,
                x: 0,
                y: 5
            )
    }
}

extension View {
    /// View에 카드 스타일 적용
    func cardStyle() -> some View {
        modifier(CardContainer())
    }
}
