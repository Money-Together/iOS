//
//  AppCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit

enum RootRoute {
    case editProfile(viewModel: EditProfileViewModel)
    case editUserAsset(viewModel: EditUserAssetViewModel)
    case editWalletProfile(viewModel: EditWalletProfileViewModel)
}

/// 앱 루트 네비게이션을 관리하는 코디네이터
class AppCoordinator: BaseNavCoordinator {
    let window: UIWindow
    
    var authCoordinator: AuthCoordinator?
    var mainTabBarCoordinator: MainTabBarCoordinator?
    
    // 현재 떠있는 child coordinator를 잡고 있다가 전환 시 해제
    private var currentChild: Coordinator?
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        switch AuthManager.shared.getInitialAuthState() {
        case .authenticated:
            self.showMainFlow()
        case .unauthenticated:
            self.showAuthFlow()
        }
    }
    
    private func showAuthFlow() {
 
        let authCoordinator = AuthCoordinator(parentCoordinator: self)
        
        // 로그인 성공 시 메인 플로우로 변경
        authCoordinator.onFinish = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {   
                self.start()
            }
        }
        
        self.authCoordinator = authCoordinator
        currentChild = authCoordinator
        authCoordinator.start()
        
        self.window.rootViewController = authCoordinator.navigationController
        self.window.makeKeyAndVisible()
    }
    
    private func showMainFlow() {
        let tabBarCoordinator = MainTabBarCoordinator(parentCoordinator: self)
        
        // 로그아웃 시, 로그인 플로우로 변경
        tabBarCoordinator.onLogout = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.start()
            }
        }
        
        self.mainTabBarCoordinator = tabBarCoordinator
        currentChild = tabBarCoordinator
        tabBarCoordinator.start()
        
        navigationController.setViewControllers([tabBarCoordinator.tabBarController], animated: true)
        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
        
    }
}

extension AppCoordinator {
   
    /// 앱 루트 네비게이션에서 지정한 경로(RootRoute)를 기준으로 화면을 push 방식으로 이동
    /// - Parameters:
    ///   - route: 이동할 화면을 나타내는 루트 경로
    ///   - animated: 애니메이션 사용 여부, 기본값 = true
    func show(_ route: RootRoute, animated: Bool = true) {
        
        let viewController: UIViewController
        
        switch route {
        case .editProfile(let viewModel):
            viewController = EditProfileViewController(viewModel: viewModel)
            
        case .editUserAsset(let viewModel):
            viewController = EditUserAssetViewController(viewModel: viewModel)

        case .editWalletProfile(let viewModel):
            viewController = EditWalletProfileViewController(viewModel: viewModel)
        }
        
        navigationController.pushViewController(viewController, animated: animated)
        
    }
    
}
