//
//  MoneyLog.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/27/25.
//

import Foundation

enum MoneyLogType {
    case expense
    case income
}

struct MoneyLog: Identifiable {
    let id = UUID()
    var date: String
    var currency: CurrencyType
    var amount: String
    var type: MoneyLogType
    var memo: String?
    
    static func createDummyData(date: String) -> MoneyLog {
        return MoneyLog(
            date: date,
            currency: .krw,
            amount: "3,000",
            type: .expense,
            memo: "#카테고리이름 #계좌이름 kdjfhlsadkfhaslkdfjhlaiwuefhlkdfjhlaikehwk kdsjfhldkasfjhadslk fjdslkf  lkdshf lksdfdlsk fl"
        )
    }
}

struct MoneyLogsByDate {
    var date: String
    var logs: [MoneyLog]
}
