//
//  SectionView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/31/25.
//

import Foundation
import UIKit

class SectionCardUIView : UIView {
    
    var title: String
    
    var content: (() -> UIView)?
    
    var titleLabel: UILabel!
    
    var contentInCardView: UIView!
    
    
    // MARK: Init & Setup
    init(title: String, content: (() -> UIView)?) {
        self.title = title
        self.content = content
        
        super.init(frame: .zero)
        
        self.setUI()
        self.setLayout()
        self.setAction()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// sub views, ui components 세팅하는 함수
    private func setUI() {
        self.titleLabel = self.createSectionTitle(text: self.title)
        self.contentInCardView = content?().applyCardStyle()
        
//        self.addSubview(titleLabel)
//        self.addSubview(contentInCardView)
    }
    
    /// sub views를 추가하고, 레이아웃을 설정하는 함수
    private func setLayout() {
        let vstack = UIStackView.makeVStack(
            distribution: .fill,
            alignment: .fill,
            spacing: 8,
            subViews: [titleLabel, contentInCardView]
        )
        
        self.addSubview(vstack)
        
        NSLayoutConstraint.activate([
            vstack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vstack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vstack.topAnchor.constraint(equalTo: self.topAnchor),
            vstack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    /// sub views, ui components에서 필요한 액션 세팅하는 함수
    private func setAction() {
        
    }
    
    private func createSectionTitle(text: String) -> UILabel {
        return UILabel.make(
            text: text,
            textColor: UIColor.moneyTogether.label.normal,
            font: .moneyTogetherFont(style: .b2),
            numberOfLines: 1
        )
    }
    
}

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

