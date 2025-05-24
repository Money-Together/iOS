//
//  UserAssetTotalAmountCellView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/14/25.
//

import Foundation
import SwiftUI

/// 유저 자산 총 금액 cell 뷰
struct UserAssetTotalAmountCellView: View {
    
    // MARK: Properties
    
    var currencyType: CurrencyType
    var amount: String
    
    var currencyTitle: String {
        "\(currencyType.code)(\(currencyType.symbol))"
    }
    
    var amountText: String {
        return amount + " " + currencyType.readableName
    }
    
    // MARK: UI Components
    
    /// 통화를 주로 사용하는 나라 국기 이미지
    var currencyFlagImage: some View {
        Image(currencyType.flagImageName)
            .resizable()
            .clipped()
            .frame(width: ComponentSize.leadingImgSize, height: ComponentSize.leadingImgSize)
            .background(Color.moneyTogether.system.green)
            .cornerRadius(ComponentSize.leadingImgSize / 2)
    }
    
    // MARK: View Layout
    
    var body: some View {
        HStack(spacing: 8) {
            currencyFlagImage
            
            Text(currencyTitle)
                .moneyTogetherFont(style: .b1)
                .foregroundStyle(Color.moneyTogether.label.normal)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            
            Text(amountText)
                .moneyTogetherFont(style: .b1)
                .foregroundStyle(Color.moneyTogether.label.normal)
                .frame(alignment: .trailing)
                .lineLimit(1)
                .layoutPriority(1)
        }
    }
}

#Preview {
    UserAssetTotalAmountCellView(currencyType: .eur, amount: "100,000,000,000,000")
}
