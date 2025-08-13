//
//  EditMoneyLogCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/9/25.
//

import Foundation
import UIKit
import SwiftUI

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

        let rootView = EditMoneyLogView(viewModel: self.viewModel)
        let hostingVC = UIHostingController(rootView: rootView)
        
        self.show(hostingVC, animated: true)
    }
}

extension EditMoneyLogCoordinator {
    /// 지갑 홈 뷰모델에 있는 페이지 전환 관련 클로져 세팅
    func setVMClosures() {

        // 머니로그 편집 페이지에서 뒤로가기
        viewModel.onBackTapped = { [weak self] in
            guard let self = self else { return }
            
            self.navigationController.dismiss(animated: true)
            self.parent?.removeChild(self)
        }

        // 정산 멤버 선택화면으로 이동
        viewModel.onSelectSettlementMember = { [weak self] selectedMembers in
            guard let self = self else { return }
            self.navigateToSettlementMemberSelection(with: selectedMembers)
        }
        
        
        
    }
}

extension EditMoneyLogCoordinator {
    private func navigateToSettlementMemberSelection(with selectedMembers: [SettlementMember]) {
        let selectableMembers = prepareSelectableMembers(with: selectedMembers)
        
        let viewModel = SettlementMemberSelectionViewModel(
            members: selectableMembers,
            onBackTapped: {
                // 변경사항 취소 & 뒤로가기
                self.navigateBack(ofType: SettlementMemberSelectionViewController.self)
            },
            onDoneTapped: { selectedMembers in
                // 변경 사항 반영 후 페이지 닫기
                let settlementMembers = selectedMembers.map {
                    $0.toSettlementMember()
                }
                self.viewModel.updateSettlementMembers(settlementMembers)
                self.navigateBack(ofType: SettlementMemberSelectionViewController.self)
            }
        )
        
        let viewController = SettlementMemberSelectionViewController(viewModel: viewModel)

        self.show(viewController, animated: true)
    }
    
    private func prepareSelectableMembers(with selectedMembers: [SettlementMember]) -> [SelectableSettlementMember] {
        let payerIDs = selectedMembers.filter{ $0.isPayer }.map { $0.id }
        let selectedIDs = selectedMembers.map { $0.id }
        
        let selectableMembers = self.viewModel.members.map {
            SelectableSettlementMember(
                id: $0.id,
                userInfo: SimpleUser(
                    userId: 0, // tmp
                    nickname: $0.nickname,
                    profileImgUrl: $0.profileImg
                ),
                isPayer: payerIDs.contains($0.id),
                isSelected: selectedIDs.contains($0.id)
            )
        }
        
        return selectableMembers
    }
}
