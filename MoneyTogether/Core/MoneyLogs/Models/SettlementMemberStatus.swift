//
//  SettlementMemberStatus.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/20/25.
//

import Foundation

/// 정산 멤버 상태
/// - 유저 상태: 활성화 / 비활성화
/// - 정산 현황: 완료 / 미완료 / 정산취소
struct SettlementMemberStatus {
    let userStatus: UserStatus
    let settlementStatus: SettlementStatus
}
