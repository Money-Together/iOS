//
//  MoneyLogCellView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/27/25.
//

import Foundation
import UIKit
import SwiftUI


class MoneyLogCell: UITableViewCell {
    static let reuseId: String = "MoneyLogCell"
    
    func configure(with data: MoneyLog) {
        self.contentConfiguration = UIHostingConfiguration {
            MoneyLogCellView(log: data)
        }
        self.selectionStyle = .none
    }
}

struct MoneyLogCellView: View {
    private var log: MoneyLog
    
    var amountText: String {
        var sign = ""
        switch log.transactionType {
        case .spending: sign = "-"
        case .earning: sign = "+"
        }
               
        return sign + " " + log.currency.symbol + log.amount
    }
    
    var amountTextColor: Color {
        switch log.transactionType {
        case .spending: return Color.moneyTogether.system.red
        case .earning: return Color.moneyTogether.system.blue
        }
    }
    
    var memoText: String {
        return log.memo ?? ""
    }
    
    init(log: MoneyLog) {
        self.log = log
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .foregroundStyle(Color.systemPointGreen)
                .frame(width: ProfileImgSize.medium, height: ProfileImgSize.medium)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(amountText)
                    .foregroundStyle(amountTextColor)
                    .moneyTogetherFont(style: .b1)
                    .lineLimit(1)
                
                if (!memoText.isEmpty) {
                    Text(memoText)
                        .foregroundStyle(Color.moneyTogether.label.alternative)
                        .moneyTogetherFont(style: .detail2)
                        .lineSpacing(2)
                        .lineLimit(3)
                }
            }

#warning("이거 어떡할까")
            Spacer()
            
        }.padding(.vertical, 4)
    }
}

#Preview {
    MoneyLogCellView(log: MoneyLog.createDummyData(date: "2025-05-25"))
}
