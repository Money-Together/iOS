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
    
    // var onDeleteAsset: ((IndexPath) -> Void)?
    
    
    // MARK: Closures For Event Handling
    
    var profileEditBtnTapped: (() -> Void)?
    
    var userAssetAddBtnTapped: (() -> Void)?
    
    var userAssetEditBtnTapped: ((UserAsset) -> Void)?
}
 
// MARK: Fetch Functions
extension MyPageViewModel {
    
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
    
    func fetchUserAssetList() {
        // api 호출
        let dummyData: [UserAsset] = Array(1...10).map { num in
            var asset = UserAsset.createDummyData()
            asset.title = "자산 \(num)"
            return asset
            
        }
            
        // 데이터 업데이트
        self.userAssets = dummyData
        
        // UI 업데이트
        self.onUserAssetsUpdated?()
    }
}

// MARK: Edit User Profile
extension MyPageViewModel {
    func handleProfileEditBtnTap() {
        self.profileEditBtnTapped?()
    }
}

// MARK: User Asset List
extension MyPageViewModel {
    func getCountOfUserAssetList() -> Int {
        return userAssets.count
    }
    
    func getUserAsset(at index: Int) -> UserAsset? {
        return userAssets[index]
    }
}

// MARK: A User Asset
extension MyPageViewModel {
    func handleUserAssetAddBtnTap() {
        self.userAssetAddBtnTapped?()
    }
    
    func handleUserAssetEditBtnTap(for id: UUID) {
        guard let index = self.userAssets.firstIndex(where: { $0.id == id }) else { return }
        
        let tappedAsset = self.userAssets[index]
        self.userAssetEditBtnTapped?(tappedAsset)
        
        print(#fileID, #function, #line, "asset edit \(tappedAsset)")
    }
    
    func deleteUserAsset(for id: UUID) { // async throws
        guard let index = self.userAssets.firstIndex(where: { $0.id == id }) else { return }
        let asset: UserAsset = userAssets[index]
        // let serverId = asset.serverId
        
        // api
        
        // success
        self.userAssets.remove(at: index)
    }
        

}
