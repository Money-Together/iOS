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
    var rootCoordinator: Coordinator?
    
    let viewModel = MyPageViewModel()
    
    init(navigationController: UINavigationController,
         parentCoordinator: Coordinator? = nil,
         rootCoordinaotr: Coordinator? = nil) {
        super.init(navigationController: navigationController, parentCoordinator: parentCoordinator)
        rootCoordinator = rootCoordinaotr
    }
    
    override func start() {
        setVMClosures()
        self.navigationController.viewControllers = [MyPageViewController(viewModel: viewModel)]
    }
}

extension MyPageCoordinator {
    func setVMClosures() {
        guard let root = self.rootCoordinator as? AppCoordinator else {
            return
        }
        
        let editProfileVM = EditProfileViewModel(orgData: self.viewModel.profile)
        
        viewModel.profileEditBtnTapped = {
            root.showProfileEditView(viewModel: editProfileVM)
        }
        
        editProfileVM.onFinishFlow = {
            root.backFromProfileEdit()
        }
    }
}

