//
//  SelectableSettlementMemberModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/26/25.
//

import Foundation

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
