//
//  MoneyLogCellItem.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/29/25.
//

import Foundation

/// 머니로그 리스트 뷰 cell 종류
/// - 날짜 헤더 -> MoneyLogDateCell로 구성
/// - 로그(거래내역) -> MoneyLogCell로 구성
enum MoneyLogCellItem {
    case date(String)
    case moneyLog(MoneyLog)
}
