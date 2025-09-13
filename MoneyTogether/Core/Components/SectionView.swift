//
//  SectionView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/31/25.
//

import Foundation
import SwiftUI

/// 카드 스타일 섹션 swiftUI View
struct SectionCardView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(title: title)
            content
                .cardStyle()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: Section Title

/// 섹션 타이틀 라벨
struct SectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .moneyTogetherFont(style: .b2)
            .foregroundStyle(Color.moneyTogether.label.normal)
            .lineLimit(1)
    }
}

// MARK: Row Title

/// 섹션 cotent 내부 row 타이틀 라벨
struct RowTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .foregroundStyle(Color.moneyTogether.label.normal)
            .moneyTogetherFont(style: .b2)
            .frame(height: 40)
            .lineLimit(1)
    }
}

