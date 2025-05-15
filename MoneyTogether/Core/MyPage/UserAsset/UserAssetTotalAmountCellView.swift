//
//  UserAssetTotalAmountCellView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/14/25.
//

import Foundation
import SwiftUI

struct UserAssetTotalAmountCellView: View {
    var currencyType: CurrencyType
    var amount: String
    
    var currencyTitle: String {
        "\(currencyType.code)(\(currencyType.symbol))"
    }
    
    var amountText: String {
        return amount + " " + currencyType.readableName
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .frame(width: ProfileImgSize.small, height: ProfileImgSize.small)
                .foregroundStyle(Color.moneyTogether.system.red)
            
            Text(currencyTitle)
                .moneyTogetherFont(style: .b1)
                .foregroundStyle(Color.moneyTogether.label.normal)
                .lineLimit(1)
                .frame(maxWidth: 80, alignment: .leading)
            
            Spacer()
            
            Text(amountText)
                .moneyTogetherFont(style: .b1)
                .foregroundStyle(Color.moneyTogether.label.normal)
                .lineLimit(1)
        }
//        .background(Color.clear)
//        .padding(8)
    }
}

#Preview {
    UserAssetTotalAmountCellView(currencyType: .eur, amount: "100,000,000,000,000")
}
