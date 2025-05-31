//
//  AppCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit


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
    /// 루트 네비게이션에서 프로필 편집 페이지 띄우기
    /// - Parameter viewModel: 프로필 편집 VC에서 필요한 뷰모델
    func showProfileEditView(viewModel: EditProfileViewModel) {
        self.navigationController.pushViewController(EditProfileViewController(viewModel: viewModel), animated: true)
    }
    
    /// 루트 네비게이션에서 유저 자산 편집 페이지 띄우기
    /// - Parameter viewModel: 유저 자산 편집 VC에서 필요한 뷰모델
    func showUserAssetEditView(viewModel: EditUserAssetViewModel) {
        self.navigationController.pushViewController(EditUserAssetViewController(viewModel: viewModel), animated: true)
    }
    
    /// 루트 네비게이션에서 push 된 프로필 편집 뷰에서 뒤로가기 실행
    /// 단순 pop 처리
    func backFromProfileEdit() {
        self.navigationController.popViewController(animated: true)
    }
    
    /// 루트 네비게이션에서 push 된 유저 자산 편집 뷰에서 뒤로가기 실행
    /// 단순 pop 처리
    func backFromUserAssetEdit() {
        self.navigationController.popViewController(animated: true)
    }
}

extension AppCoordinator {
    func showWalletSettingView(viewModel: WalletViewModel) {
        self.navigationController.pushViewController(WalletSettingViewController(viewModel: viewModel), animated: true)
    }
}
