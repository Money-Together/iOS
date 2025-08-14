//
//  EditMoneyLogViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/9/25.
//

import Foundation

class EditMoneyLogViewModel: ObservableObject {
    
    let walletData: Wallet
    
    let members: [WalletMember]
    
    // money log data
    
    @Published var category: Category? = nil
    
    @Published var settlementMembers: [SettlementMember] = []
    
    
    // closures to navigate
    
    var onBackTapped: (() -> Void)?
    
    var onSelectSettlementMember: (([SettlementMember]) -> Void)?
    
    var onSelectCategory: (() -> Void)?
    
    
    // init
    
    init(walletData: Wallet,
         walletMembers: [WalletMember]) {
        self.walletData = walletData
        self.members = walletMembers
    }
}

extension EditMoneyLogViewModel {
    
    /// 머니로그 카테고리 업데이트
    /// - Parameter newValue: 업데이트 할 데이터, 카테고리 선택이 안된 경우 nil
    func updateCategory(_ newValue: Category?) {
        self.category = newValue
    }
    
    /// 정산멤버 리스트 업데이트
    func updateSettlementMembers(_ newValue: [SettlementMember]) {
        self.settlementMembers = newValue
    }
}
