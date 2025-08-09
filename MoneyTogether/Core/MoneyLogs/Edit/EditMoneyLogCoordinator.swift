//
//  EditMoneyLogCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/9/25.
//

import Foundation
import UIKit

class EditMoneyLogCoordinator: BaseNavCoordinator {

    var viewModel: EditMoneyLogViewModel!
    
    init(parentCoordinator: Coordinator? = nil,
         walletData: Wallet,
         walletMembers: [WalletMember]) {
        
        self.viewModel = EditMoneyLogViewModel(walletData: walletData, walletMembers: walletMembers)
        
        let nav = UINavigationController()
        nav.setNavigationBarHidden(true, animated: false)
        
        super.init(navigationController: nav, parentCoordinator: parentCoordinator)
    }
    
    override func start() {
        setVMClosures()
        self.show(EditMoneyLogViewController(viewModel: viewModel), animated: true)
    }
}

extension EditMoneyLogCoordinator {
    /// 지갑 홈 뷰모델에 있는 페이지 전환 관련 클로져 세팅
    func setVMClosures() {

        viewModel.onBackTapped = { [weak self] in
            guard let self = self else { return }
            
            self.navigationController.dismiss(animated: true)
            self.parent?.removeChild(self)
        }

        viewModel.onSelectSettlementMember = { [weak self] in
            guard let self = self else { return }
            let viewController = SettlementMemberSelectionViewController(
                members: self.viewModel.members,
                onBackTapped: {
                    self.navigateBack(ofType: SettlementMemberSelectionViewController.self)
                },
                onDoneTapped: { selectedMembers in
                    self.viewModel.updateSettlementMembers(selectedMembers)
                }
            )
            self.show(viewController, animated: true)
        }
        
        
        
    }
}
