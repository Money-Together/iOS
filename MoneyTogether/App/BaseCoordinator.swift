//
//  BaseCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parent: Coordinator? { get set }
    var children: [Coordinator] { get set }
    
    func start()
}

class BaseNavCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parent: Coordinator?
    var children: [Coordinator] = []
    
    init(parentCoordinator: Coordinator? = nil) {
        self.navigationController = UINavigationController()
        self.parent = parentCoordinator
    }
    
    init(navigationController: UINavigationController,
         parentCoordinator: Coordinator? = nil) {
        self.navigationController = navigationController
        self.parent = parentCoordinator
    }
    
    func start() {
        fatalError("Start method should be implemented.")
    }
}

class BaseTabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController
    var children: [Coordinator] = []
    var parent: Coordinator?
    
    init(parentCoordinator: Coordinator? = nil) {
        self.tabBarController = UITabBarController()
        self.parent = parentCoordinator
    }
    
    init(tabBarController: UITabBarController,
         parentCoordinator: Coordinator? = nil) {
        self.tabBarController = tabBarController
        self.parent = parentCoordinator
    }
    
    func start() {
        fatalError("Start method should be implemented.")
    }
}
