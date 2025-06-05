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
        
        viewModel.walletSettingBtnTapped = { [weak self] in
            guard let self = self else { return }
            root.show(.walletSetting(viewModel: self.viewModel.walletVM))
        }
        
        viewModel.walletVM.walletMembersPreviewTapped = { members in
            root.show(.walletMemberList(members: members))
        }
        
        viewModel.walletVM.walletEditBtnTapped = { [weak self] in
            guard let self = self else { return }
            root.show(.editWalletProfile(viewModel: self.viewModel.walletVM))
        }
        
        viewModel.walletVM.onBackTapped = { target in
            switch target {
            case .walletSetting:
                root.navigateBack(ofType: WalletSettingViewController.self, animated: true)
            case .editWallet:
                root.navigateBack(ofType: EditWalletProfileViewController.self, animated: true)
            default: return
            }
            
        }
        
    }
}
