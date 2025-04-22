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

