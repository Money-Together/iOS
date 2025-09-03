//
//  CategoryCell.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/4/25.
//

import Foundation
import UIKit
import SwiftUI

/// 카테고리 테이블 뷰 cell
final class CategoryCell: UITableViewCell {
    static let reuseId = "CategoryCell"
    func configure(_ data: Category) {
        self.contentConfiguration = UIHostingConfiguration {
            CategoryCellView(category: data)
        }
        self.selectionStyle = .none
    }
}

/// 카테고리 테이블 뷰 cell swiftUI view
struct CategoryCellView: View {
    var name: String
    var color: PaletteColor
    var icon: Icon
    
    init(category: Category) {
        self.name = category.name
        self.color = category.color
        self.icon = category.icon
    }
    
    var body: some View {
        HStack {
            CategoryImageView(
                color: color.color,
                iconName: icon.name,
                size: ComponentSize.leadingImgSize
            )
            
            Text(name)
                .moneyTogetherFont(style: .b2)
                .foregroundStyle(Color.moneyTogether.label.normal)
        }
    }
}
