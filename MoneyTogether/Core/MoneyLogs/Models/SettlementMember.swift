//
//  SettlementMember.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/19/25.
//

import Foundation

/// 정산 멤버
struct SettlementMember: Identifiable {
    let id: UUID = UUID()
    let userInfo: SimpleUser
    var isPayer: Bool
    let isMe: Bool
    var amount: String
    let status: SettlementMemberStatus
    
    static func createDummyData(isPayer: Bool = false, isMe: Bool = false, status: SettlementMemberStatus = SettlementMemberStatus(userStatus: .active, settlementStatus: .completed)) -> Self {
        SettlementMember(
            userInfo: SimpleUser(
                userId: 1,
                nickname: "홍길동",
                profileImgUrl: "https://i.pravatar.cc"
            ),
            isPayer: isPayer,
            isMe: isMe,
            amount: "2,000",
            status: status)
    }
}
