//
//  MainTabBarCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit

// MARK: Main TabBarItem Type
/// 메인 탭에 포함되는 탭 타입
enum MainTabBarItemType: String, CaseIterable {
    case walletHome, myPage
    
    /// Int형에 맞춰 초기화
    init?(index: Int) {
        switch index {
        case 0: self = .walletHome
        case 1: self = .myPage
        default: return nil
        }
    }
    
    /// TabBar Item type과 매칭되는 Int형으로 반환
    func toInt() -> Int {
        switch self {
        case .walletHome: return 0
        case .myPage: return 1
        }
    }
    
    /// TabBar Item Title
    func getTitle() -> String {
        switch self {
        case .walletHome: return "home"
        case .myPage: return "my"
        }
    }
    
    /// TabBar Item SelectedImageName
    func getSelectedImageName() -> String  {
        switch self {
        case .walletHome: return "house.fill"
        case .myPage: return "person.fill"
        }
    }
    
    /// TabBar Item ImageName
    func getImageName() -> String  {
        switch self {
        case .walletHome: return "house"
        case .myPage: return "person"
        }
    }

}

// MARK: Main Tab Coordinator
/// 메인 탭뷰 코디네이터
class MainTabBarCoordinator: BaseTabBarCoordinator {
    
    override func start() {
        let tabs = MainTabBarItemType.allCases
        
        // 탭바 아이템 생성
        let tabBarItems = tabs.map{
            self.createTabBarItem(of: $0)
        }
        
        // 각 탭의 네비게이션 컨트롤러 생성
        let tabNavigationControllers = tabBarItems.map {
            self.createTabNavigationController(tabBarItem: $0)
        }
        
        // 하위 코디네이터 실행
        tabNavigationControllers.forEach { nav in
            self.startTabCoordinator(with: nav)
        }
        
        // 탭바컨트롤러 기본 세팅
        self.configureTabBarController(with: tabNavigationControllers)
        
    }
}

// MARK: setup to start
extension MainTabBarCoordinator {
    
    /// 탭바컨트롤러 기본 세팅 (view controllers, selected index, style)
    private func configureTabBarController(with tabNavigationControllers: [UINavigationController]) {
        
        // TabBar의 VC 지정
        self.tabBarController.setViewControllers(tabNavigationControllers, animated: false)
        
        // home의 index로 TabBar Index 세팅
        self.tabBarController.selectedIndex = MainTabBarItemType.walletHome.toInt()
        
        // TabBar 스타일 지정
        self.tabBarController.tabBar.tintColor = UIColor.black
        
    }
    
    /// 탭바 아이템 생성
    private func createTabBarItem(of type: MainTabBarItemType) -> UITabBarItem {
        let item = UITabBarItem (
            title: type.getTitle(),
            image: UIImage(systemName: type.getImageName()),
            selectedImage: UIImage(systemName: type.getSelectedImageName())
        )
        item.tag = type.toInt()
    
        return item
    }
    
    /// 각 탭에 해당하는 네비게이션 컨트롤러 생성
    /// 탭바 아이템과 네비게이션 컨트롤러 연결
    private func createTabNavigationController(tabBarItem: UITabBarItem) -> UINavigationController {
        let nav = UINavigationController()

        // 상단에서 NavigationBar 숨김
        nav.setNavigationBarHidden(true, animated: false)
        // tabBarItem 설정을 통해 NavigationController와 tabBarItem를 연결
        nav.tabBarItem = tabBarItem

        return nav
    }
    
    /// 각 탭과 연결되는 하위 코디네이터 실행
    /// 코디네이터와 네비게이션 컨트롤러 연결
    private func startTabCoordinator(with tabNavigationController: UINavigationController) {
        // tag 번호로 tab bar item type 가져오기
        let tabBarItemTag: Int = tabNavigationController.tabBarItem.tag
        guard let tabBarItemType = MainTabBarItemType(index: tabBarItemTag) else {
            return
        }

        // 코디네이터 생성 및 실행
        switch tabBarItemType {
        case .walletHome:
            let walletHomeCoordinator = WalletHomeCoordinator(navigationController: tabNavigationController, parentCoordinator: self, rootCoordinaotr: self.parent)
            walletHomeCoordinator.start()
            self.children.append(walletHomeCoordinator)
            
        case .myPage:
            let myPageCoordinator = MyPageCoordinator(navigationController: tabNavigationController, parentCoordinator: self, rootCoordinaotr: self.parent)
            myPageCoordinator.start()
            self.children.append(myPageCoordinator)
        }
    }
    
}


