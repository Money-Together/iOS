//
//  EditWalletProfileViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/14/25.
//

import Foundation

class EditWalletProfileViewModel {
    /// 지갑 프로필 데이터 편집 상태
    struct WalletDataEditState {
        var nameEditState: InputEditState<String>
        var bioEditState: InputEditState<String>
        var cashboxAmountEditState: InputEditState<String>
        var cashboxBioEditState: InputEditState<String>
        var hasCashboxEditState: InputEditState<Bool>
        
        /// 지갑 프로필 텍스트 데이터
        var allTextDataEditStates: [InputEditState<String>] {
            [self.nameEditState, self.bioEditState, self.cashboxAmountEditState, self.cashboxBioEditState]
        }
        
        init(nameEditState: InputEditState<String>, bioEditState: InputEditState<String>, cashboxAmountEditState: InputEditState<String>, cashboxBioEditState: InputEditState<String>, hasCashboxEditState: InputEditState<Bool>) {
            self.nameEditState = nameEditState
            self.bioEditState = bioEditState
            self.cashboxAmountEditState = cashboxAmountEditState
            self.cashboxBioEditState = cashboxBioEditState
            self.hasCashboxEditState = hasCashboxEditState
        }
    }
    
    private var mode: EditingMode<Wallet>
    
    /// 기존 데이터
    /// 변경 여부 확인을 위함
    private(set) var orgData: Binder<Wallet?> = Binder(nil)
    
    var dataEditState: WalletDataEditState!
    
    /// 지갑 프로필 편집 완료 버튼 활성화 여부
    private(set) var isCompleteBtnEnable: Binder<Bool> = Binder(false)
    
    /// 에러 alert 표시 여부
    private(set) var isErrorAlertVisible: Binder<Bool> = Binder(false)
    
    /// 뒤로가기 버튼 클릭 시 호출되는 클로져
    var onBackTapped: ((WalletHomeRouteTarget) -> Void)?
    
    /// 편집 완료 시 호출되는 클로져
    /// 업데이트된 지갑 데이터를 보냄
    var onUpdated: ((Wallet) -> Void)?
    
    
    // MARK: Init
    
    init(mode: EditingMode<Wallet> = .create) {
        self.mode = mode

        switch self.mode {
        case .create:
            self.initData()
        case .update(let orgData):
            self.initData(with: orgData)
        }
    }
    
    /// 데이터 상태값 초기화
    /// - 새로운 지갑프로필 생성 시에 호출 (orgData == nil, editingMode == .create)
    /// - 필수 데이터: wallet name -> invalid
    /// - 선택 데이터: wallet bio, cashbox amount(저금통 사용 시 필수), cashbox bio -> .updated, default = ""
    /// - 항상 값이 있는 데이터: has cashbox -> .updated, default = false
    func initData() {
        
        self.dataEditState = WalletDataEditState(
            nameEditState: .invalid,
            bioEditState: .updated(newValue: ""),
            cashboxAmountEditState: .updated(newValue: ""),
            cashboxBioEditState: .updated(newValue: ""),
            hasCashboxEditState: .updated(newValue: false))
    }
    
    /// orgData 및 데이터 상태값 초기화
    /// - 지갑프로필 수정 시에 호출 (orgData != nil, editingMode == .update)
    /// 전부 .unchanged로 초기화
    func initData(with orgData: Wallet) {
        self.orgData.value = orgData
        
        self.dataEditState = WalletDataEditState(
            nameEditState: .unchanged,
            bioEditState: .unchanged,
            cashboxAmountEditState: .unchanged,
            cashboxBioEditState: .unchanged,
            hasCashboxEditState: .unchanged
        )
    }
}

extension EditWalletProfileViewModel {
    /// 지갑 프로필 편집 취소
    /// - 이전 페이지로 이동함
    func cancelWalletProfileEditing() {
        self.onBackTapped?(.editWallet)
    }
    
    /// 지갑 프로필 편집 완료
    func completeWalletProfileEditing() {
        guard isCompleteBtnEnable.value else {
            return
        }
        
        var updatedData: Wallet
        var baseCurrency: CurrencyType = .krw
        
        // editing mode에 따라 업데이트 데이터 초기화
        // - 생성 모드: default 데이터로 초기화 후 업데이트된 데이터 반영
        // - 수정 모드: original 데이터로 초기화 후 업데이트된 데이터 반영
        switch mode {
        case .create:
            updatedData = Wallet(
                name: "",
                baseCurrency: baseCurrency,
                hasCashBox: false,
                cashBox: CashBox(
                    amount: "",
                    currency: baseCurrency,
                    bio: ""
                )
            )
        case .update(let orgData):
            updatedData = orgData
            baseCurrency = updatedData.baseCurrency
            if updatedData.cashBox == nil {
                updatedData.cashBox = CashBox(amount: "", currency: baseCurrency, bio: "")
            }
        }
        
        // 업데이트된 데이터 반영
        if let newName = dataEditState.nameEditState.newValue {
            updatedData.name = newName
        }
        if let newBio = dataEditState.bioEditState.newValue {
            updatedData.bio = newBio
        }
        if let hasCashbox = dataEditState.hasCashboxEditState.newValue {
            updatedData.hasCashBox = hasCashbox
        }
        if let newCashboxAmount = dataEditState.cashboxAmountEditState.newValue {
            updatedData.cashBox?.amount = newCashboxAmount
        }
        if let newCashboxBio = dataEditState.cashboxBioEditState.newValue {
            updatedData.cashBox?.bio = newCashboxBio
        }
        
        
        // api
        
        // if success
        self.onUpdated?(updatedData)
        self.onBackTapped?(.editWallet)
        
        // if fail
        // self.isErrorAlertVisible.value = true
    }
    
    /// 지갑 프로필 편집을 완료할 수 있는 상태인지 확인
    /// - 모든 데이터가 유효한 형태이고, 변경된 데이터가 있을 경우 편집 완료 가능
    ///
    /// - Returns: 편집 완료 가능 여부, 가능하면 true & isCompleteBtnEnable = true
    private func canCompleteWalletProfileEditing() -> Bool {
        
        // 모든 데이터가 유효한지 확인
        var allValid = dataEditState.allTextDataEditStates.allSatisfy { state in
            switch state {
            case .invalid: return false
            default: return true
            }
        }
        allValid = dataEditState.hasCashboxEditState == .invalid ? false : allValid
        
        // 변경된 데이터가 있는지 확인
        var hasUpdated = dataEditState.allTextDataEditStates.contains { state in
            switch state {
            case .updated: return true
            default: return false
            }
        }
        hasUpdated = dataEditState.hasCashboxEditState.newValue != nil ? true : hasUpdated
        
        return allValid && hasUpdated
    }
}

extension EditWalletProfileViewModel {
    
    /// 지갑 프로필 데이터 입력 상태 설정
    /// - Parameters:
    ///   - inputType: 데이터 타입
    ///   - state: 입력 상태
    private func setEditSate(of inputType: WalletProfileInputType, state: InputEditState<String>) {
        switch inputType {
        case .name:
            self.dataEditState.nameEditState = state
        case .bio:
            self.dataEditState.bioEditState = state
        case .cashboxAmount:
            self.dataEditState.cashboxAmountEditState = state
        case .cashboxBio:
            self.dataEditState.cashboxBioEditState = state
        }
    }
    
    /// 편집 전 기존 데이터를 가져오는 함수
    /// - Parameter inputType: 데이터 타입, 텍스트 타입 데이터만
    /// - Returns: 기존 데이터
    private func originalValue(of inputType: WalletProfileInputType) -> String? {
        guard let orgData = self.orgData.value else {
            return nil
        }
        
        switch inputType {
        case .name:             return orgData.name
        case .bio:              return orgData.bio
        case .cashboxAmount:    return orgData.cashBox?.amount
        case .cashboxBio:       return orgData.cashBox?.bio
        }
    }
    
    /// 지갑 프로필 데이터 편집 상태 업데이트 ( 텍스트 타입 데이터)
    /// - 타입 별 validate 검사 후 유효하지 않을 경우 -> invalid
    /// - 기존 데이터와 동일한지 확인 후 동일할 경우 -> unchanged
    /// - 유효하고, 기존 데이터와 달라진 경우 -> updated(new value)
    /// - 편집 상태 변경 후, 편집 완료 버튼 활성화 여부 확인
    /// - Parameters:
    ///   - inputType: 데이터 타입
    ///   - value: 새로 입력된 값
    func updateWalletProfileDataEditState(of inputType: WalletProfileInputType, value: String) {
        let hasCashbox: Bool = (dataEditState.hasCashboxEditState.newValue ?? self.orgData.value?.hasCashBox) ?? false
        
        guard inputType.validate(value, hasCashbox: hasCashbox) else {
            self.setEditSate(of: inputType, state: .invalid)
            self.isCompleteBtnEnable.value = false
            return
        }
        
        let originalValue = self.originalValue(of: inputType) ?? ""
        if value == originalValue {
            self.setEditSate(of: inputType, state: .unchanged)
        } else {
            self.setEditSate(of: inputType, state: .updated(newValue: value))
        }
        
        self.isCompleteBtnEnable.value = self.canCompleteWalletProfileEditing()
    }
    
    /// 지갑 저금통 사용 여부 편집 상태 업데이트 ( Bool 타입 데이터 )
    /// - 기존 데이터와 동일한지 확인 후 동일할 경우 -> unchanged
    /// - 기존 데이터와 달라진 경우 -> updated(new value)
    /// - 편집 상태 변경 후, 편집 완료 버튼 활성화 여부 확인
    /// - Parameters:
    ///   - value: 새로 입력된 값
    func updateHasCashBoxEditState(_ value: Bool) {
        let originalValue = self.orgData.value?.hasCashBox ?? false
        if value == originalValue {
            self.dataEditState.hasCashboxEditState = .unchanged
        } else {
            self.dataEditState.hasCashboxEditState = .updated(newValue: value)
        }
        
        self.isCompleteBtnEnable.value = self.canCompleteWalletProfileEditing()
    }
}
