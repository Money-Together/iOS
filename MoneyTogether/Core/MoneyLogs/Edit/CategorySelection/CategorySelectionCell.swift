//
//  CategorySelectionCell.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/14/25.
//

import Foundation
import UIKit
import SwiftUI

class CategorySelectionCell: UICollectionViewCell {
    static let reuseId = "CategorySelectionCell"
    
    func configure(with data: Category) {
        self.contentConfiguration = UIHostingConfiguration {
            CategorySelectionCellView(data: data)
        }
        
//        self.backgroundColor = .yellow
    }
}

struct CategorySelectionCellView: View {
    var data: Category
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 20) {
                Circle()
                    .frame(width: ProfileImgSize.large)
                
                Spacer()
            }
            
            Text(data.name)
                .moneyTogetherFont(style: .b2)
                .foregroundStyle(Color.moneyTogether.label.normal)
                .lineLimit(1)
                .padding(.bottom, 8)
        }
    }
}

#Preview {
    let list = Category.createDummyList()
    
    HStack {
        CategorySelectionCellView(data: list[0])
        CategorySelectionCellView(data: list[1])
        CategorySelectionCellView(data: list[2])
    }
}
