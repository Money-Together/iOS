//
//  EditMoneyLogViewModel+Validate.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/31/25.
//

import Foundation

extension EditMoneyLogViewModel {
    
    enum MoneyLogInputError: String {
        case emptyAmount = "금액을 입력해주세요."
        case invalidAmount = "금액을 올바르게 입력해주세요."
        
        case emptyCategory = "카테고리를 선택해주세요."
        case invalidCategory = "카테고리가 유효하지 않습니다."
        
        case emptySettlementMember = "1명 이상의 정산 멤버가 필요합니다."
        case invalidSettlementAmount = "정산 금액을 다시 확인해주세요."
        
        case emptyAsset = "자산을 선택해주세요."
        
        case cashboxUnavailable = "저금통을 사용할 수 없습니다."
        
        case commonInputError = "입력 정보를 확인해주세요."
        
        case none = ""
        
        var messege: String {
            return self.rawValue
        }
    }
    
    /// 금액 유효성 검사
    private func validateAmount() -> Bool {
        guard !amount.isEmpty else {
            self.errorType = .emptyAmount
            return false
        }
        
        guard amount.isDecimalStyleWithComma() else {
            self.errorType = .invalidAmount
            return false
        }
        
        return true
    }
    
    /// 정산 멤버 유효성 검사
    private func validateSettlementMembers() -> Bool {

        // 정산 멤버 사용 X
        // - 지출 타입이 아닌 경우
        // - 나만 보기 사용 시
        if transactionType != .spending || isPrivate {
            self.updateSettlementMembers([])
            return true
        }
        
        // 정산 멤버 적어도 1명 이상
        guard !settlementMembers.isEmpty else {
            self.errorType = .emptySettlementMember
             return false
        }
        
        // 거래 금액 >= 정산 금액 총합
        guard isValidLeftAmount else {
            self.errorType = .invalidSettlementAmount
            return false
        }
        
        return true
    }
    
    /// 자산 유효성 검사
    private func validateAsset() -> Bool {
        
        // 저금통 사용 시, 개인 자산 사용 불가
        if useCashbox {
            self.updateAsset(nil)
            return true
        }
        
        // 나만 보기 사용 시, 자산 선택 필수
        if isPrivate {
            if asset == nil {
                self.errorType = .emptyAsset
                return false
            }
            return true
        }
        
        // 나만 보기 X일 경우, 지출 타입은 자산 선택 불가
        if transactionType == .spending {
            self.updateAsset(nil)
            return true
        }
        
        // 수입타입, 나만보기 X, 저금통 X - 자산 선택 필수
        if asset == nil {
            self.errorType = .emptyAsset
            return false
        }
        return true
        
    }
    
    func validate() -> Bool {
        self.errorType = .none
        
        if !canUseCashbox {
            self.updateCashboxUsage(false)
        }
        
        // 입력된 금액이 유효한지 확인
        guard validateAmount() else {
            return false
        }
        
        // 카테고리
        guard category != nil else {
            self.errorType = .emptyCategory
            return false
        }
        
        // 나만 보기 & 저금통 동시 사용 불가
        if isPrivate && useCashbox {
            self.errorType = .cashboxUnavailable
            return false
        }
           
        // 자산이 유효한지 확인
        guard validateAsset() else {
            return false
        }

        // 정산 멤버 리스트가 유효한지 확인
        guard validateSettlementMembers() else {
            return false
        }
        
        return true
    }
    
}


