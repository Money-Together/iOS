//
//  AppCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit


class AppCoordinator: BaseNavCoordinator {
    
    var mainTabBarCoordinator: MainTabBarCoordinator?
    
    override func start() {
        let tabBarCoordinator = MainTabBarCoordinator(parentCoordinator: self)
        self.mainTabBarCoordinator = tabBarCoordinator
        tabBarCoordinator.start()
        
        navigationController.setViewControllers([tabBarCoordinator.tabBarController], animated: true)
    }
}

