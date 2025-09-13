//
//  LoginViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/10/25.
//

import Foundation
import Combine

/// 로그인 뷰모델
class LoginViewModel {
    
    /// 로그인 진행상태
    /// Combine을 위한 Published 속성
    @Published private(set) var isLoginInProgress: Bool = false

    /// 로그인 진행 상태에 따른 로그인 버튼 활성화 여부
    /// 바인딩용 퍼블리셔 노출
    var isLoginButtonEnabled: AnyPublisher<Bool, Never> {
        $isLoginInProgress
            .map { !$0 }
            .eraseToAnyPublisher()
    }
    
    // Output
    /// 로그인 성공 시
    var onLoginSuccess: (() -> Void)?
    /// 로그인 실패 시
    var onLoginFailure: ((Error) -> Void)?
    
    func login(with loginType: SocialLoginType) {
        guard !isLoginInProgress else { return }
        
        self.beginLoginFlow()
        Task {
            do {
                let tokens = try await AuthService.shared.login(with: loginType)
                AuthManager.shared.loginSucceeded(token: tokens)
                self.onLoginSuccess?()
            } catch {
                self.onLoginFailure?(error)
            }
            self.endLoginFlow()
        }
    }
        
    private func beginLoginFlow() {
        self.isLoginInProgress = true
    }
    
    private func endLoginFlow() {
        self.isLoginInProgress = false
    }
     
}

extension LoginViewModel {
    /// 애플 로그인 테스트용
    func loginWithApple() {
        guard !isLoginInProgress else { return }
        
        self.beginLoginFlow()
        Task {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                if Bool.random() { // success
                    self.onLoginSuccess?()
                } else { // fail
                    throw AuthError.unknown
                }
            } catch {
                self.onLoginFailure?(error)
            }
            self.endLoginFlow()
        }
    }

}
