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

/// 네비게이션 타입 기본 코디네이터
/// 네비게이션바 hidden 이 default
class BaseNavCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parent: Coordinator?
    var children: [Coordinator] = []
    
    init(parentCoordinator: Coordinator? = nil) {
        self.navigationController = UINavigationController()
        self.navigationController.isNavigationBarHidden = true
        self.parent = parentCoordinator
    }
    
    init(navigationController: UINavigationController,
         parentCoordinator: Coordinator? = nil) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
        self.parent = parentCoordinator
    }
    
    func start() {
        fatalError("Start method should be implemented.")
    }
    
    /// 네비게이션에서 주어진 뷰 컨트롤러를 push 방식으로 화면 이동
    /// - Parameters:
    ///   - viewController: 이동할 화면 뷰컨트롤러
    ///   - animated: 애니메이션 사용 여부, 기본값 = true
    func show(_ viewController: UIViewController, animated: Bool) {
        self.navigationController.pushViewController(viewController, animated: animated)
    }
    
    /// 네비게이션 스택의 최상단 뷰컨트롤러가 지정한 타입일 경우, 해당 화면을 pop 방식으로 뒤로가기 실행
    /// - Parameters:
    ///   - type: pop 할 대상 뷰컨트롤러 타입
    ///   - animated: 애니메이션 사용 여부, 기본값 = true
    func navigateBack<T: UIViewController>(ofType type: T.Type, animated: Bool = true) {
        if navigationController.topViewController is T {
            navigationController.popViewController(animated: animated)
        }
    }
}

/// 탭바 타입 기본 코디네이터
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
