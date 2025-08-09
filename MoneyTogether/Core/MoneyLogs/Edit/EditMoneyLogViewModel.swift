//
//  EditMoneyLogViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/9/25.
//

import Foundation

class EditMoneyLogViewModel {
    
    let walletData: Wallet
    
    let members: [WalletMember]
    
    var settlementMembers: [SettlementMember] = []
    
    
    // closures to navigate
    
    var onBackTapped: (() -> Void)?
    
    var onSelectSettlementMember: (() -> Void)?
    
    init(walletData: Wallet,
         walletMembers: [WalletMember]) {
        self.walletData = walletData
        self.members = walletMembers
    }
}

extension EditMoneyLogViewModel {
    
    /// 정산멤버 리스트 업데이트
    func updateSettlementMembers(_ newValue: [SettlementMember]) {
        self.settlementMembers = newValue
    }
}
