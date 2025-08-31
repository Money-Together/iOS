//
//  MoneyLog.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/27/25.
//

import Foundation

/// 머니로그 거래 타입
enum TransactionType: String {
    case spending  // 소비, 지출
    case earning   // 수입
//    case something
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .spending: return "지출"
        case .earning: return "수입"
        default: return "테스트"
        }
    }
}

extension TransactionType: SliderSegmentedPickable {}

struct MoneyLog: Identifiable {
    let id = UUID()
    var date: String
    var currency: CurrencyType
    var amount: String
    var transactionType: TransactionType
    var memo: String?
    
    static func createDummyData(date: String) -> MoneyLog {
        return MoneyLog(
            date: date,
            currency: .krw,
            amount: "3,000",
            transactionType: .spending,
            memo: "#식비 #우리은행 | 오늘 점심으로 친구들과 엽떡 + 허니콤보 먹음. 역시 너무 맛있었다. 또 먹고 싶다. 아직도 60자밖에 안된다. 근데 사실 내 최애는 고추바사삭 최대 100자"
        )
    }
}

struct MoneyLogsByDate {
    var date: String
    var logs: [MoneyLog]
}
