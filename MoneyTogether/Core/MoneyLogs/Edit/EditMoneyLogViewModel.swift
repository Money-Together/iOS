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
    
    
    // error
    @Published var hasEditingError: Bool = false
    
    var errorType: MoneyLogInputError = .none
    
    
    
    // money log data
    
    @Published var transactionType: TransactionType = .spending
    
    /// 통화 타입
    @Published private(set) var currencyType: CurrencyType
    
    /// 금액
    @Published var amount: String = ""
    
    /// 날짜
    @Published private(set) var date: Date = Date()
    
    /// 카테고리
    @Published private(set) var category: Category? = nil
    
    /// 나만 보기 여부
    @Published private(set) var isPrivate: Bool = false
    
    /// 메모
    @Published var memo: String = ""
    
    /// 저금통 사용 여부
    @Published private(set) var useCashbox: Bool = false
    
    /// 자산
    @Published private(set) var  asset: UserAsset? = nil
    
    /// 정산 멤버
    @Published private(set) var settlementMembers: [SettlementMember] = []
    
    /// 정산 멤버 별 정산 금액 편집 가능 여부
    var canEditSettlementAmount: Bool {
        !useCashbox
    }
    
    /// 총 금액 - 정산 금액 총합이 유효한지 여부
    var isValidLeftAmount: Bool {
        return leftAmount != "앗! 총액을 초과했어요. 금액을 다시 확인해주세요."
    }
    
    /// 총 금액 - 정산 금액 총합
    var leftAmount: String {
        let amount = Decimal(string: self.amount.replacingOccurrences(of: ",", with: "")) ?? 0
        
        let sum = self.settlementMembers
            .compactMap{ Decimal(string:$0.amount.replacingOccurrences(of: ",", with: "")) }
            .reduce(Decimal(0)) { $0 + $1 }
        
        if amount < sum {
            return "앗! 총액을 초과했어요. 금액을 다시 확인해주세요."
        } else {
            return "남은 금액: \(amount - sum)"
        }
    }
    
    /// 저금통 사용 가능 여부
    /// - 나만 보기일 경우, 불가능
    /// - 저금통을 비활성화한 경우, 불가능
    var canUseCashbox: Bool {
        let canUse = isPrivate ? false : true
        
        return canUse
        
    }
    
    
    // closures to navigate
    
    var onBackTapped: (() -> Void)?
    
    var onCurrencyTypeSelection: (() -> Void)?
    
    var onSelectSettlementMember: (([SettlementMember]) -> Void)?
    
    var onSelectDate: (() -> Void)?
    
    var onSelectCategory: (() -> Void)?
    
    var onSelectAsset: (() -> Void)?
    
    
    // init
    
    init(walletData: Wallet,
         walletMembers: [WalletMember]) {
        self.walletData = walletData
        self.members = walletMembers
        
        self.currencyType = walletData.baseCurrency
    }
}

extension EditMoneyLogViewModel {
    func completeEdit()  {
        guard validate() else {
            self.hasEditingError = true
            return
        }
        
        // do action
        
        // if success
        self.onBackTapped?()
        return
        
        // if fail
//        self.errorType = .commonInputError
//        self.hasEditingError = true
        
    }
}

extension EditMoneyLogViewModel {
    
    /// 통화 타입 업데이트
    func updateCurrencyType(_ newValue: CurrencyType) {
        self.currencyType = newValue
    }
    
    /// 금액 업데이트
    /// decimal 스타일로 수정하여 변경
    func updateAmountText(with input: String) {
        // 입력값 선택된 통화에 맞는 decimal 스타일로 변환
        let decimalString = input.replacingOccurrences(of: ",", with: "").decimalWithPoint()
        if self.amount != decimalString {
            self.amount = decimalString
            self.initSettlementMemberAmount()
        }
    }
    
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
        
        // 나만보기 사용 시 - 저금통 사용 불가 & 개인 자산 선택 가능
        if isPrivate {
            self.useCashbox = false
        }
    }

    /// 저금통 사용 여부 업데이트
    func updateCashboxUsage(_ newValue: Bool) {
        if canUseCashbox {
            self.useCashbox = newValue
            
            // 저금통 사용 시 정산 멤버 별 정산 금액 모두 동일하게 설정됨
            if self.useCashbox {
                initSettlementMemberAmount()
            }
        }
    }
    
    /// 정산멤버 리스트 업데이트
    func updateSettlementMembers(_ newValue: [SettlementMember]) {
        self.settlementMembers = newValue
        self.initSettlementMemberAmount()
    }
    
    /// 모든 정산 멤버의 정산 금액을 동일하게 설정 (1/n 더치페이)
    func initSettlementMemberAmount() {
        let total = self.amount.toDecimal() ?? 0
        
        let perMemberAmount = total / Decimal(settlementMembers.count)
        
        settlementMembers.enumerated().forEach { idx, member in
            settlementMembers[idx].amount = "\(perMemberAmount)".decimalStyle()
        }
    }
    
    /// 정산멤버(member)의 정산 금액을 업데이트
    func updateSettlementMemberAmount(of member: SettlementMember, with newValue: String) {
        guard let idx = self.settlementMembers.firstIndex(where: { $0.id == member.id }) else {
            return
        }
        
        self.settlementMembers[idx].amount = newValue
        
    }
    
    /// 자산 업데이트
    func updateAsset(_ newValue: UserAsset?) {
        self.asset = newValue
    }
    
    /// 메모 업데이트
    func updateMemo(_ newValue: String) {
        self.memo = String(newValue.prefix(100))
    }
}

