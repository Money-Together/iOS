//
//  UserProfileModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/28/25.
//

import Foundation

/// 유저 프로필 모델
struct UserProfile {
    var nickname:   String
    var email:      String
    var imageUrl:   String?
    
    /// 유저 프로필 더미 데이터 생성 함수
    static func createDummyData() -> Self {
        return UserProfile(nickname: "test용최대10자",
                           email: "testEmail@gmail.com",
                           imageUrl: "https://i.pravatar.cc")
    }
}

/* api response를 UserProfile로 변환
 extension UserProfile {
 init(response: UserResponse) {
 
 }
 }
 */
