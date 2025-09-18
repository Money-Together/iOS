//
//  AuthManager.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/9/25.
//

import Foundation

final class TokenRepository {
    private let key = "moenytogether.auth.tokenpair"

    func save(_ token: TokenPair) {
        let data = try? JSONEncoder().encode(token)
        UserDefaults.standard.set(data, forKey: key)
    }

    func load() -> TokenPair? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(TokenPair.self, from: data)
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

final class AuthManager {
    static let shared = AuthManager()
    
    private let tokenRepo = TokenRepository()
    
    private(set) var currentToken: TokenPair?
    
    /// 로그아웃 시 호출
    /// AppCoordinator에서 로그인 플로우로 변경
    var onLogout: (() -> Void)?
    
    private init() {}

    /// 앱 시작 시 분기용
    func getInitialAuthState() -> AppLaunchState {
        if let token = tokenRepo.load() {
            currentToken = token
            return .authenticated
        } else {
            return .unauthenticated
        }
    }

    /// 로그인 성공 후 저장
    func loginSucceeded(token: TokenPair) {
        tokenRepo.save(token)
        currentToken = token
    }

    /// 로그아웃 시, 저장된 토큰 삭제 및 플로우 변경을 위한 클로져 호출
    func logout() {
        tokenRepo.clear()
        currentToken = nil
        self.onLogout?()
    }
}

