//
//  EditUserAssetViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/17/25.
//

import Foundation

enum InputEditState<T: Equatable>: Equatable {
    case empty
    case unchanged
    case updated(newValue: T)
    case invalid

    var newValue: T? {
        if case let .updated(value) = self {
            return value
        }
        return nil
    }
}

final class EditUserAssetViewModel {
    
    /// 기존 데이터
    /// 변경 여부 확인을 위함
     private(set) var orgData: Binder<UserAsset?> = Binder(nil)
    
    /// 편집 완료 버튼 활성화 여부
    private(set) var isCompleteBtnEnable: Binder<Bool> = Binder(false)
    
    /// 에러 alert 표시 여부
    private(set) var isErrorAlertVisible: Binder<Bool> = Binder(false)
    
    private(set) var currencyType: Binder<CurrencyType> = Binder(.krw)
    
    
    private var assetNameEditState: InputEditState<String> = .empty {
        didSet {
            self.canCompleteUserAssetEdit()
        }
    }
    
    private var assetCurrencyTypeState: InputEditState<CurrencyType> = .empty {
        didSet {
            self.canCompleteUserAssetEdit()
        }
    }
    
    private var assetAmountEditState: InputEditState<String> = .empty {
        didSet {
            self.canCompleteUserAssetEdit()
        }
    }

    private var assetBioEditState: InputEditState<String> = .empty {
        didSet {
            self.canCompleteUserAssetEdit()
        }
    }
    
    // MARK: Closures For Navigation
    
    /// 화면 전환(이전페이지로)을 위한 클로져
    /// 수정 취소/완료 시에 호출
    var onFinishFlow: (() -> Void)?
    
    
    // MARK: Init
    
    init(orgData: UserAsset? = nil) {
//        self.orgData = orgData
        
        // 새로운 자산을 생성하는 경우
        guard let orgData = orgData else {
            // 통화 타입은 항상 값이 존재
            // 새로운 자산을 생성하는 경우에도 기본 통화가 자동 선택되어 있음
            self.assetCurrencyTypeState = .updated(newValue: self.currencyType.value)
            
            // 필수 데이터 상태값 초기화
            self.assetNameEditState = .invalid
            self.assetAmountEditState = .invalid
            
            // 선택 테이터 상태값 초기화
            self.assetBioEditState = .updated(newValue: "")
            
            return
        }
    }
    
    func setOrgData(with orgData: UserAsset) {
        self.orgData.value = orgData
        
        // orgData가 존재 = 자산을 수정하는 경우
        self.currencyType.value = orgData.currencyType
        self.assetNameEditState = .unchanged
        self.assetAmountEditState = .unchanged
        self.assetBioEditState = .unchanged
        self.assetCurrencyTypeState = .unchanged
    }
}

extension EditUserAssetViewModel {
    func cancelUserAssetEdit() {
        self.onFinishFlow?()
    }
    
    func completeUserAssetEdit() {
        let name = self.assetNameEditState.newValue ?? "no value"
        let amount = self.assetAmountEditState.newValue ?? "no value"
        let currencyType = self.currencyType.value
        let bio = self.assetBioEditState.newValue ?? "no value"
        
        print(#fileID, #function, #line, "complete with {\(name), \(amount), \(currencyType.displayName), \(bio)}")
        
        guard isCompleteBtnEnable.value else {
            return
        }
        
        // api
        
        // if success
        self.onFinishFlow?()
        
        // if fail
        // self.isErrorAlertVisible.value = true
        
    }
    
    func canCompleteUserAssetEdit() {
        var allValid = [assetNameEditState, assetAmountEditState, assetBioEditState].allSatisfy { state in
            switch state {
            case .unchanged, .updated: return true
            default: return false
            }
        }
        
        var hasUpdated = [assetNameEditState, assetAmountEditState, assetBioEditState].contains {
            switch $0 {
            case .updated: return true
            default: return false
            }
        }
        
        if case .invalid = assetCurrencyTypeState {
            allValid = false
        } else if case .updated = assetCurrencyTypeState {
            hasUpdated = true
        }
        
        // 완료 버튼 활성화 여부 설정
        guard allValid && hasUpdated else {
            self.isCompleteBtnEnable.value = false
            return
        }
        
        self.isCompleteBtnEnable.value = true

    }
}

// MARK: Validator
extension EditUserAssetViewModel {
    /// 자산 이름 유효성 검사
    ///
    /// 유효한 자산 이름 조건
    /// - 필수 정보, 값이 존재
    /// - 10자 이내
    /// - 중복 불가능
    func validateAssetName(value: String) -> Bool {
        
        if value.isEmpty {
            return false
        }
        if value.count > 10 {
             return false
        }
        
        return true
    }
    
    /// 자산 금액 유효성 검사
    ///
    /// 유효한 자산 이름 조건
    /// - 필수 정보, 값이 존재
    /// - 숫자만 가능
    /// - 15 자 이내...?
    func validateAssetAmount(value: String) -> Bool {
        if value.isEmpty {
            return false
        }
        
        // 최소 1 ~ 최대 15자, 숫자, 소수점, ,
        let regex = "^[0-9.,]{1,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: value)
        
        return isValid
    }
    
    /// 자산 설명 유효성 검사
    ///
    /// 유효한 자산 설명 조건
    /// - 선택 정보, 값이 없어도 됨
    /// - 20 자 이내
    func validateAssetBio(value: String) -> Bool {
        
        if value.count > 20 {
             return false
        }
        
        return true
    }
}

// MARK: update Data
extension EditUserAssetViewModel {
    /// 자산 이름 유효성 확인 후 업데이트
    /// - Parameter newValue: 새로운 데이터
    func updateAssetName(newValue: String) {
        if !validateAssetName(value: newValue) {
            assetNameEditState = .invalid
        } else if newValue == orgData.value?.title {
            assetNameEditState = .unchanged
        } else {
            assetNameEditState = .updated(newValue: newValue)
        }
    }
    
    /// 자산 통화 타입 유효성 확인 후 업데이트
    /// - Parameter newValue: 새로운 데이터
    func updateAssetCurrencyType(newValue: CurrencyType) {
        if newValue == orgData.value?.currencyType {
            assetCurrencyTypeState = .unchanged
        } else {
            assetCurrencyTypeState = .updated(newValue: newValue)
            self.currencyType.value = newValue
        }
    }
    
    /// 자산 금액 유효성 확인 후 업데이트
    /// - Parameter newValue: 새로운 데이터
    func updateAssetAmount(newValue: String) {
        if !validateAssetAmount(value: newValue) {
            assetAmountEditState = .invalid
        } else if newValue == orgData.value?.amount {
            assetAmountEditState = .unchanged
        } else {
            assetAmountEditState = .updated(newValue: newValue)
        }
    }
    
    /// 자산 설명 유효성 확인 후 업데이트
    /// - Parameter newValue: 새로운 데이터
    func updateAssetBio(newValue: String) {
        if !validateAssetBio(value: newValue) {
            assetBioEditState = .invalid
        } else if newValue == orgData.value?.amount {
            assetBioEditState = .unchanged
        } else {
            assetBioEditState = .updated(newValue: newValue)
        }
    }
}
