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
    case walletSetting(viewModel: WalletViewModel)
    case editWalletProfile(viewModel: WalletViewModel)
    case walletMemberList(members: [WalletMember])
}

enum RootRouteTarget {
    case walletSetting
    case editWallet
}

/// 앱 루트 네비게이션을 관리하는 코디네이터
class AppCoordinator: BaseNavCoordinator {
    
    var mainTabBarCoordinator: MainTabBarCoordinator?
    
    override func start() {
        let tabBarCoordinator = MainTabBarCoordinator(parentCoordinator: self)
        self.mainTabBarCoordinator = tabBarCoordinator
        tabBarCoordinator.start()
        
        navigationController.setViewControllers([tabBarCoordinator.tabBarController], animated: true)
    }
}

extension AppCoordinator {
    /// 앱 루트 네비게이션에서 주어진 뷰 컨트롤러를 push 방식으로 화면 이동
    /// - Parameters:
    ///   - viewController: 이동할 화면 뷰컨트롤러
    ///   - animated: 애니메이션 사용 여부, 기본값 = true
    func show(_ viewController: UIViewController, animated: Bool) {
        self.navigationController.pushViewController(viewController, animated: animated)
    }
    
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
            
        case .walletSetting(let viewModel):
            viewController = WalletSettingViewController(viewModel: viewModel)
            
        case .editWalletProfile(let viewModel):
            viewController = EditWalletProfileViewController(viewModel: viewModel)
            
        case .walletMemberList(let members):
            viewController = WalletMemberListViewController(members: members, onBackTapped: { [weak self] in
                guard let self = self else { return }
                self.navigationController.popViewController(animated: true)
            })
        }
        
        navigationController.pushViewController(viewController, animated: animated)
        
    }
    
    /// 앱 루트 네비게이션 스택의 최상단 뷰컨트롤러가 지정한 타입일 경우, 해당 화면을 pop 방식으로 뒤로가기 실행
    /// - Parameters:
    ///   - type: pop 할 대상 뷰컨트롤러 타입
    ///   - animated: 애니메이션 사용 여부, 기본값 = true
    func navigateBack<T: UIViewController>(ofType type: T.Type, animated: Bool = true) {
        if navigationController.topViewController is T {
            navigationController.popViewController(animated: animated)
        }
    }
}
