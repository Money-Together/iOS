//
//  EditProfileViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/6/25.
//

import Foundation

enum ProfileImageUpdateState: Equatable {
    case unchanged
    case resetToDefault
    case updated(Data)
}

/// 유저 프로필 수정 뷰모델
class EditProfileViewModel {
    
    /// 기존 데이터
    /// 변경 여부 확인을 위함
    private(set) var orgData: UserProfile
    
    /// 수정 완료 버튼 활성화 여부
    private(set) var isCompleteBtnEnable: Binder<Bool> = Binder(false)
    
    /// 에러 alert 표시 여부
    private(set) var isErrorAlertVisible: Binder<Bool> = Binder(false)
    
    /// 프로필 이미지 변경 여부
    var profileImageUpdateState: ProfileImageUpdateState = .unchanged {
        didSet {
            // 프로필 이미지 상태 변경 시, 완료 버튼 활성화 여부 검사
            canCompleteProfileEdit()
        }
    }
    
    /// 닉네임 변경 여부
    lazy var isNicknameUpdated: (String) -> Bool = { [unowned self] newValue in
        return self.orgData.nickname != newValue
    }
    
    /// 닉네임 유효성 여부
    private(set) var isNicknameValid: Bool = false {
        didSet {
            // 닉네임 유효성 여부 확인 시, 완료 버튼 활성화 여부 검사
            canCompleteProfileEdit()
        }
    }
    
    
    // MARK: Closures For Navigation
    
    /// 화면 전환(이전페이지로)을 위한 클로져
    /// 수정 취소/완료 시에 호출
    var onFinishFlow: (() -> Void)?
    
    
    // MARK: Init
    
    init(orgData: UserProfile) {
        self.orgData = orgData
    }

}


// MARK: Cancel / Complete Action Handling

extension EditProfileViewModel {
    func cancelProfileEdit() {
        self.onFinishFlow?()
    }
    
    func completeProfileEdit(nickname: String) {
        print(#fileID, #function, #line, "complete with {\(nickname), }")
        
        guard isCompleteBtnEnable.value else {
            return
        }
        
        // api
        
        // if success
        self.onFinishFlow?()
        
        // if fail
        // self.isErrorAlertVisible.value = true
        
    }
    
    func canCompleteProfileEdit() {
        isCompleteBtnEnable.value = isNicknameValid || profileImageUpdateState != .unchanged
    }
    
}


// MARK: Validator

extension EditProfileViewModel {
    
    func validateNickname(value: String) -> Bool {
        
        guard isNicknameUpdated(value) else {
            self.isNicknameValid = false
            return false
        }
        
        // 최소 2 ~ 최대 10자, 특수문자 불가능
        let nicknameRegex = "^[A-Za-z0-9가-힣ㄱ-ㅎㅏ-ㅣ]{2,10}$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        let isValid = nicknamePredicate.evaluate(with: value)
        
        self.isNicknameValid = isValid
        
        return isValid
    }
}
