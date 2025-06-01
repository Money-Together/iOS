//
//  WalletHomeCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit

class WalletHomeCoordinator: BaseNavCoordinator {
    var rootCoordinator: Coordinator?
    
    let viewModel = WalletHomeViewModel()
    
    
    init(navigationController: UINavigationController,
         parentCoordinator: Coordinator? = nil,
         rootCoordinaotr: Coordinator? = nil) {
        super.init(navigationController: navigationController, parentCoordinator: parentCoordinator)
        rootCoordinator = rootCoordinaotr
    }
    
    override func start() {
        setVMClosures()
        self.navigationController.viewControllers = [WalletHomeViewController(viewModel: viewModel)]
    }
}

extension WalletHomeCoordinator {
    /// 지갑 홈 뷰모델에 있는 페이지 전환 관련 클로져 세팅
    func setVMClosures() {
        guard let root = self.rootCoordinator as? AppCoordinator else {
            return
        }
        
        viewModel.walletSettingBtnTapped = {
            root.showWalletSettingView(viewModel: self.viewModel.walletVM)
        }
        
        viewModel.walletVM.walletMembersPreviewTapped = { members in
            root.showWalletMemberListView(members: members)
        }
        
    }
}
