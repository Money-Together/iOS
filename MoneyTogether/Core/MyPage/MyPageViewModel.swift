//
//  MyPageViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/27/25.
//

import Foundation

/// 마이페이지 뷰모델
final class MyPageViewModel {
    
    // MARK: Data
    var profile: UserProfile = UserProfile.createDummyData()

    
    // MARK: Closures For Binding
    
    /// binding 용 클로져
    /// 데이터 업데이트 시 ViewController에게 알림
    var onProfileUpdated: (() -> Void)?
    
    // MARK: Closures For Event Handling
    
    var profileEditBtnTapped: (() -> Void)?
    
    var onCancelProfileEdit: (() -> Void)?

    
    // MARK: Fetch Functions
    
    /// 서버에서 유저 프로필 정보 가져오는 함수
    func fetchUserProfile() {
        // api 호출
        let dummyData = UserProfile.createDummyData()
        
        // 데이터 업데이트
        self.profile = dummyData

        // UI 업데이트
        onProfileUpdated?()
    }
}

extension MyPageViewModel {
    func handleProfileEditBtnTap() {
        self.profileEditBtnTapped?()
    }
    
    func cancelProfileEdit() {
        self.onCancelProfileEdit?()
    }
}
