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
    
    /// 날짜
    @Published private(set) var date: Date = Date()
    
    /// 카테고리
    @Published private(set) var category: Category? = nil
    
    /// 나만 보기 여부
    @Published private(set) var isPrivate: Bool = true
    
    /// 저금통 사용 여부
    @Published var useCashbox: Bool = false
    
    /// 정산 멤버
    @Published private(set) var settlementMembers: [SettlementMember] = []
    
    /// 저금통 사용 가능 여부
    /// - 나만 보기일 경우, 불가능
    /// - 저금통을 비활성화한 경우, 불가능
    var canUseCashbox: Bool {
        isPrivate ? false : true
    }
    
    
    // closures to navigate
    
    var onBackTapped: (() -> Void)?
    
    var onSelectSettlementMember: (([SettlementMember]) -> Void)?
    
    var onSelectDate: (() -> Void)?
    
    var onSelectCategory: (() -> Void)?
    
    
    // init
    
    init(walletData: Wallet,
         walletMembers: [WalletMember]) {
        self.walletData = walletData
        self.members = walletMembers
    }
}

extension EditMoneyLogViewModel {
    
    /// 날짜 업데이트
    func updateDate(_ newValue: Date) {
        self.date = newValue
    }
    
    /// 머니로그 카테고리 업데이트
    /// - Parameter newValue: 업데이트 할 데이터, 카테고리 선택이 안된 경우 nil
    func updateCategory(_ newValue: Category?) {
        self.category = newValue
    }
    
    /// 나만보기 여부 업데이트
    func updatePrivateState(_ newValue: Bool) {
        self.isPrivate = newValue
    }

    /// 정산멤버 리스트 업데이트
    func updateSettlementMembers(_ newValue: [SettlementMember]) {
        self.settlementMembers = newValue
    }
}


