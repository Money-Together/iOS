//
//  CategoryImageView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/1/25.
//

import Foundation
import SwiftUI

/// 카테고리 색상과 아이콘으로 구성된 이미지 뷰
struct CategoryImageView: View {
    var color: Color
    var iconName: String
    var size: CGFloat
    
    var body: some View {
        Image(iconName)
            .iconStyle(
                size: size / 2,
                foregroundColor: Color.moneyTogether.label.rNormal,
                padding: size / 4
            )
            .background(color)
            .clipShape(Circle())
    }
}
