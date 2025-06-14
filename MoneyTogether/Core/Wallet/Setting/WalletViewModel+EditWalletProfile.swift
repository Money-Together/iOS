//
//  WalletViewModel+EditWalletProfile.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/3/25.
//

import Foundation

/// 지갑 프로필 입력 데이터 타입
/// 지갑이름, 한줄소개, 저금통 금액, 저금통설명
enum WalletProfileInputType {
    case name, bio, cashboxAmount, cashboxBio
    
    /// 입력데이터 최대 길이
    var maxLength: Int {
        switch self {
        case .name:             return 15
        case .bio:              return 50
        case .cashboxAmount:    return 15
        case .cashboxBio:       return 20
        }
    }
    
    /// 유효성 여부 확인 함수
    /// - Parameters:
    ///   - value: 확인할 데이터
    ///   - hasCashbox: 저금통 사용여부, 저금통을 사용하지 않을 경우, 저금통 금액은 필수 정보가 아님
    /// - Returns: 유효성 여부, 유효할 경우 true
    func validate(_ value: String, hasCashbox: Bool = false) -> Bool {
        switch self {
        case .name:
            return value.count > 0 && value.count <= maxLength
        case .bio:
            return value.count <= maxLength
        case .cashboxAmount:
            guard hasCashbox else { return true }
            guard value.replacingOccurrences(of: ",", with: "").isDecimalStyle() else { return false }
            return value.count > 0 && value.count <= maxLength
        case .cashboxBio:
            return hasCashbox ? value.count <= maxLength : true
        }
    }
}

extension WalletViewModel {
    /// 지갑 프로필 데이터 편집 상태
    struct WalletDataEditState {
        var nameEditState: InputEditState<String> = .empty
        var bioEditState: InputEditState<String> = .empty
        var cashboxAmountEditState: InputEditState<String> = .empty
        var cashboxBioEditState: InputEditState<String> = .empty
        var hasCashboxEditState: InputEditState<Bool> = .unchanged
        
        /// 지갑 프로필 텍스트 데이터
        var allTextDataEditStates: [InputEditState<String>] {
            [self.nameEditState, self.bioEditState, self.cashboxAmountEditState, self.cashboxBioEditState]
        }
    }
}


// MARK: Edit Finish Flow
extension WalletViewModel {
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
        
        let newName = dataEditState.nameEditState.newValue
        let newBio = dataEditState.bioEditState.newValue
        let hasCashbox = dataEditState.hasCashboxEditState.newValue
        let newCashboxAmount = dataEditState.cashboxAmountEditState.newValue
        let newCashboxBio = dataEditState.cashboxBioEditState.newValue
        
        let updatedData = Wallet(
            name: newName ?? originalValue(of: .name) ?? "",
            bio: newBio ?? originalValue(of: .bio),
            baseCurrency: walletData?.baseCurrency ?? .krw,
            hasCashBox: hasCashbox ?? walletData?.hasCashBox ?? true,
            cashBox: CashBox(
                amount: newCashboxAmount ?? originalValue(of: .cashboxAmount) ?? "",
                currency: walletData?.baseCurrency ?? .krw,
                bio: newCashboxBio ?? originalValue(of: .cashboxBio)
            )
        )
        
        // api
        
        // if success
        self.walletData = updatedData
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

// MARK: Update Wallet Profile Data
extension WalletViewModel {
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
        switch inputType {
        case .name:             return self.walletData?.name
        case .bio:              return self.walletData?.bio
        case .cashboxAmount:    return self.walletData?.cashBox?.amount
        case .cashboxBio:       return self.walletData?.cashBox?.bio
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
        let hasCashbox: Bool = (dataEditState.hasCashboxEditState.newValue ?? self.walletData?.hasCashBox) ?? false
        
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
        let originalValue = self.walletData?.hasCashBox ?? false
        if value == originalValue {
            self.dataEditState.hasCashboxEditState = .unchanged
        } else {
            self.dataEditState.hasCashboxEditState = .updated(newValue: value)
        }
        
        self.isCompleteBtnEnable.value = self.canCompleteWalletProfileEditing()
    }
}
