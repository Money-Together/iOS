//
//  MyPageCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit

/// 마이페이지 코드네이터
class MyPageCoordinator: BaseNavCoordinator {
    
    override func start() {
        let viewModel = MyPageViewModel()
        self.navigationController.viewControllers = [MyPageViewController(viewModel: viewModel)]
    }
}
