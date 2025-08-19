//
//  SettlementStatus.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/19/25.
//

import Foundation

/// 정산 상태
/// - 정산완료, 미완료, 정산취소
enum SettlementStatus {
    case completed
    case pending
    case cancelled
    
    var description: String {
        switch self {
        case .completed:    return "정산 완료"
        case .pending:      return "미정산"
        case .cancelled:    return "정산 취소"
        }
    }
}
