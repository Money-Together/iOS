//
//  WalletViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/26/25.
//

import Foundation

class WalletViewModel: ObservableObject {
    
    @Published var walletData: Wallet?
    @Published var members: [WalletMember] = []
    
    /// 지갑멤버 프리뷰 클릭 시 호출되는 클로져
    var walletMembersPreviewTapped: (([WalletMember]) -> Void)?
}


// MARK: Fetch Functions
extension WalletViewModel {
    /// 서버에서 지갑 프로필 정보 가져오는 함수
    func fetchWalletData() {
        // api 호출
        let dummyData = Wallet.createDummyData()
        
        // 데이터 업데이트
        self.walletData = dummyData
    }
    
    func fetchMembers() {
        // api 호출
        let dummyData: [WalletMember] = Array(0..<100).map { idx in
            WalletMember.createDummyData(nickname: "user\(idx)")
        }
        
        // 데이터 업데이트
        self.members = dummyData
    }
}
