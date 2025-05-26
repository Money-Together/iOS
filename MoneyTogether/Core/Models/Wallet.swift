//
//  Wallet.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/26/25.
//

import Foundation

struct CashBox {
    var amount: String
    var currency: CurrencyType
    var bio: String?
}

struct walletMember: Identifiable {
    var id: UUID
    var nickname: String
    var profileImg: String
}

struct Wallet {
    var name: String
    var bio: String?
    var baseCurrency: CurrencyType
    var hasCashBox: Bool
    var cashBox: CashBox?
    
    static func createDummyData() -> Wallet {
        return Wallet(
            name: "지갑이름은최대15자입니다아아",
            bio: "지갑 설명이 길게 길게 가능하지 않을까?? 줄여서 보여줘야 할까 최대 50자",
            baseCurrency: .krw,
            hasCashBox: true,
            cashBox: CashBox(
                amount: "10,000",
                currency: .krw
            )
        )
    }
}
