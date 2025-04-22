//
//  MyPageCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit

class MyPageCoordinator: BaseNavCoordinator {
    
    override func start() {
        self.navigationController.viewControllers = [MyPageViewController()]
    }
}
