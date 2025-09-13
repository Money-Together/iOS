//
//  AuthCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/10/25.
//

import Foundation

/// auth flow coordinator
class AuthCoordinator: BaseNavCoordinator {
    
    var viewModel = LoginViewModel()
    
    /// auth flow 완료 시
    /// 로그인 완료 시 호출됨
    var onFinish: (() -> Void)?
    
    override func start() {
        self.setVMClosures()
        
        let loginViewController = LoginViewController(viewModel: self.viewModel)
        self.navigationController.viewControllers = [loginViewController]
    }
    
    private func setVMClosures() {
        // 로그인 성공 시 finish closure 호출
        viewModel.onLoginSuccess = { [weak self] in
            guard let self = self else { return }
            self.onFinish?()
        }
    }
}

