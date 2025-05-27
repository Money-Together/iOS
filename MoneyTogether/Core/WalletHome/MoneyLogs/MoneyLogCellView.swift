//
//  MoneyLogCellView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/27/25.
//

import Foundation
import UIKit
import SwiftUI

class MoneyLogTableViewCell: UITableViewCell {
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
        switch log.type {
        case .expense: sign = "-"
        case .income: sign = "+"
        }
               
        return sign + " " + log.currency.symbol + log.amount
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
                    .foregroundStyle(Color.moneyTogether.label.normal)
                    .moneyTogetherFont(style: .b1)
                    .lineLimit(1)
                
                if (!memoText.isEmpty) {
                    Text(memoText)
                        .foregroundStyle(Color.moneyTogether.label.assistive)
                        .moneyTogetherFont(style: .detail2)
                        .lineLimit(2)
                }
            }

#warning("이거 어떡할까")
            Spacer()

            
        }.padding(.vertical, 4)
    }
}

