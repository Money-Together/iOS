//
//  UserService.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/18/25.
//

import Foundation
import Moya

final class UserService {
    
    static let shared = UserService()
    
    private let provider = MoyaProvider<UserTarget>(plugins: [NetworkLoggerPlugin(), AuthPlugin()])
    
    private init() {}
}

extension UserService {
    func getUserProfile() async throws -> UserProfile {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getUserProfile) { result in
                switch result {
                case .success(let response):
                    do {
                        let domainData = try response.map(UserResponse.self).toDomain()
                        continuation.resume(returning: domainData)
                    } catch {
                        continuation.resume(throwing: NetworkError.decodingFailed)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

}
