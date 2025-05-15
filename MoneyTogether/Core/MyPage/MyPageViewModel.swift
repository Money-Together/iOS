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
    
    var userAssetTotalAmounts: [CurrencyType : String] = [:]
    var userAssets: [UserAsset] = []

    
    // MARK: Closures For Binding
    // binding 용 클로져
    // 데이터 업데이트 시 ViewController에게 알림
    
    /// 유저 프로필 바인딩 용 클로져
    var onProfileUpdated: (() -> Void)?
    
    /// 자산 통화별 총 금액 바인딩 용 클로져
    var onUserAssetTotalAmountsUpdated: (() -> Void)?
    
    /// 유저 자산 리스트 바인딩 용 클로져
    var onUserAssetsUpdated: (() -> Void)?
    
    
    // MARK: Closures For Event Handling
    
    var profileEditBtnTapped: (() -> Void)?

    
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
    
    func fetchUserAssetsTotalAmounts() {
        // api 호출
        let dummyData: [CurrencyType: String] = [
            .krw: "1,000,000,000,000",
            .usd: "1,000",
            .jpy: "100,000,000"
        ]
            
        // 데이터 업데이트
        self.userAssetTotalAmounts = dummyData
        
        // UI 업데이트
        self.onUserAssetTotalAmountsUpdated?()
    }
}

extension MyPageViewModel {
    func handleProfileEditBtnTap() {
        self.profileEditBtnTapped?()
    }
    
    
    
    
}
