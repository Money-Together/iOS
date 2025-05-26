//
//  UserAsset.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/15/25.
//

import Foundation

/// 사용자 자산
struct UserAsset: Identifiable {
    var id = UUID()
    var title: String
    var bio: String
    var amount: String
    var currencyType: CurrencyType
    
    static func createDummyData() -> Self {
        return UserAsset(
            title: "자산1",
            bio: "간단한 자산 설명 최대 20자",
            amount: "100,000",
            currencyType: .krw)
    }
}
