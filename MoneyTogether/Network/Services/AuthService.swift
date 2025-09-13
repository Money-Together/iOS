//
//  AuthService.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/6/25.
//

import UIKit
import Moya
import FirebaseCore
import FirebaseAuth

final class AuthService {
    
    static let shared = AuthService()
    
    private let authAPIProvider = MoyaProvider<AuthTarget>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
}

extension AuthService {
    
    /// 소셜로그인 credential 생성 및 파이어베이스, 서버 로그인 진행
    /// - 로그인 진행 중 오류 발생 시 error throw
    ///
    /// - Parameter socialLogin: 소셜 로그인 타입
    /// - Returns: 로그인 성공 시 (accessToken, refreshToken) 페어
    func login(with socialLogin: SocialLoginType) async throws -> TokenPair {
        let credential = socialLogin.credential
        let firebaseToken = try await doFirebaseLogin(credential: credential)
        
        let data = try await doServerLogin(loginType: socialLogin, token: firebaseToken)
        
        return data
    }
    
    private func doFirebaseLogin(credential: AuthCredential) async throws -> String {
        // firebase login
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let user = Auth.auth().currentUser else {
                    continuation.resume(throwing: AuthError.unknown)
                    return
                }
                
                user.getIDToken { idToken, error in
                    guard let idToken = idToken, error == nil else {
                        continuation.resume(throwing: AuthError.unknown)
                        return
                    }
                    
                    continuation.resume(returning: idToken)
                }
            }
        }
    }
    
    private func doServerLogin(loginType: SocialLoginType, token: String) async throws -> TokenPair {
        return try await withCheckedThrowingContinuation { continuation in
            authAPIProvider.request(.login(type: loginType, accessToken: token)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map(TokenPair.self)
                        continuation.resume(returning: data)
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
