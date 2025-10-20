//
//  UserResponse.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/18/25.
//

import Foundation

struct UserResponse: BaseResponse {
    var id: Int64?
    var nickname: String?
    var email: String?
    var image: String? // data 타입으로 이후 수정될 수 있음
}

extension UserResponse {
    typealias domainType = UserProfile
    
    func toDomain() -> UserProfile {
        return UserProfile(
            nickname: self.nickname ?? "no name",
            email: self.email ?? "",
            imageUrl: nil
        )
    }
}
