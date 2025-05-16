//
//  UserAssetCellView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/15/25.
//

import Foundation
import SwiftUI

/// 유저 자산 리스트 cell 뷰
struct UserAssetCellView: View {
    
    // MARK: Properties
    
    let title: String
    let amountText: String
    let bio: String
    
    init(userAsset: UserAsset) {
        self.title = userAsset.title
        self.amountText = "\(userAsset.amount) \(userAsset.currencyType.readableName)"
        self.bio = userAsset.bio
    }
    
    
    // MARK: View layout
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 12) {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .moneyTogetherFont(style: .b1)
                
                Text(amountText)
                    .frame(alignment: .trailing)
                    .moneyTogetherFont(style: .b1)
                    .lineLimit(1)
                    .layoutPriority(1)
                
            }
            
            Text(bio)
                .moneyTogetherFont(style: .b2)
                .foregroundStyle(Color.moneyTogether.label.assistive)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
            
        }
    }
}


#Preview {
    UserAssetCellView(userAsset: UserAsset.createDummyData())
}
