//
//  SelectableSettlementMemberModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/26/25.
//

import Foundation

/// 선택 가능한 정산 멤버
/// - 정산 멤버 선택 화면에서 사용됨
/// - 기본적인 유저 정보,  결제자 선택 여부, 정산 참여 여부
class SelectableSettlementMember: NSObject {
    let id: UUID
    let userInfo: SimpleUser
    var isPayer: Bool
    var isSelected: Bool
    
    init(id: UUID = UUID(), userInfo: SimpleUser, isPayer: Bool, isSelected: Bool) {
        self.id = id
        self.userInfo = userInfo
        self.isPayer = isPayer
        self.isSelected = isSelected
    }
}

extension SelectableSettlementMember {
    /// selectable 정산 멤버를 settlement member 모델로 변환
    func toSettlementMember() -> SettlementMember {
        SettlementMember(
            userInfo: self.userInfo,
            isPayer: self.isPayer,
            isMe: false,
            amount: "0",
            status: .init(userStatus: .active, settlementStatus: .pending)
        )
    }
}
