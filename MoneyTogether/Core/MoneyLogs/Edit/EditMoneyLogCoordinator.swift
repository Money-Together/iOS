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
    
    var rootViewController: UIHostingController<EditMoneyLogView>!
    
    init(parentCoordinator: Coordinator? = nil,
         walletData: Wallet,
         walletMembers: [WalletMember]) {
        
        self.viewModel = EditMoneyLogViewModel(walletData: walletData, walletMembers: walletMembers)
        
        let nav = UINavigationController()
        nav.setNavigationBarHidden(true, animated: false)
        
        super.init(navigationController: nav, parentCoordinator: parentCoordinator)
    }
    
    override func start() {
        let rootView = EditMoneyLogView(viewModel: self.viewModel)
        self.rootViewController = UIHostingController(rootView: rootView)
        self.rootViewController.hideKeyboardWhenTappedAround()
        
        self.show(self.rootViewController, animated: true)
        
        setVMClosures()
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
        
        // 통화 타입 선택 모달 띄우기
        viewModel.onCurrencyTypeSelection = { [weak self] in
            guard let self = self else { return }
            self.presentCurrencyTypeSelection()
        }
        
        // 날짜 선택 모달 띄우기
        viewModel.onSelectDate = { [weak self] in
            guard let self = self else { return }
            self.presentDatePicker()
            
        }
        
        // 카테고리 선택 모달 띄우기
        viewModel.onSelectCategory = { [weak self] in
            guard let self = self else { return }
            self.presentCategorySelection()
        }
        
        // 자산 선택 모달 띄우기
        viewModel.onSelectAsset = { [weak self] in
            guard let self = self else { return }
            self.presentAssetSelection()
        }

        // 정산 멤버 선택화면으로 이동
        viewModel.onSelectSettlementMember = { [weak self] selectedMembers in
            guard let self = self else { return }
            self.navigateToSettlementMemberSelection(with: selectedMembers)
        }
    }
}

extension EditMoneyLogCoordinator {
    
    /// 통화 타입 선택 모달 띄우기
    private func presentCurrencyTypeSelection() {
        let viewController = CurrencyTypePickerViewController(defaultCurrency: self.viewModel.currencyType)
        viewController.selectedCurrency.bind({ newValue in
            self.viewModel.updateCurrencyType(newValue)
        })
        
        self.navigationController.showSheet(viewController: viewController, detents: [.fixedHeight(400), .large()])
    }
    
    /// 날짜 선택 모달 띄우기
    private func presentDatePicker() {
        let rootView = DatePickerView(
            date: self.viewModel.date,
            onDone: { date in
                self.viewModel.updateDate(date)
            }
        )
        let hostingVC = UIHostingController(rootView: rootView)
        
        self.rootViewController.showSheet(viewController: hostingVC, detents: [.fixedHeight(400)])
    }
    
    /// 카테고리 선택 모달 띄우기
    private func presentCategorySelection() {
        let viewController = CategorySelectionViewController()
//            viewController.onBackBtnTapped = {
//                viewController.dismiss(animated: true)
//            }
        viewController.onSelect = { selected in
            print(#fileID, #function, #line, "selected category: \(selected.name)")
            self.viewModel.updateCategory(selected)
            viewController.dismiss(animated: true)
        }

        self.rootViewController.showSheet(
            viewController: viewController,
            detents: [.fixedHeight(400), .large()]
        )
    }
    
    /// 자산 선택 모달 띄우기
    private func presentAssetSelection() {
        let viewController = AssetSelectionViewController()
        viewController.onSelect = { selected in
            self.viewModel.updateAsset(selected)
            viewController.dismiss(animated: true)
        }
        
        self.rootViewController.showSheet(viewController: viewController, detents: [.fixedHeight(400)])
    }
}

extension EditMoneyLogCoordinator {
    /// 정산 멤버 선택 뷰로 이동
    /// - Parameter selectedMembers: 이전에 선택된 정산 멤버 리스트
    private func navigateToSettlementMemberSelection(with selectedMembers: [SettlementMember]) {
        // 정산 멤버 선택 뷰에서 사용되는 selectableMember 모델로 변환
        let selectableMembers = prepareSelectableMembers(with: selectedMembers)
        
        // 정산 멤버 선택 뷰모델
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
        
        // 정산 멤버 선택 뷰 컨트롤러
        let viewController = SettlementMemberSelectionViewController(viewModel: viewModel)

        // 화면 이동
        self.show(viewController, animated: true)
    }
    
    /// 정산 멤버 선택 뷰에서 필요한 데이터 준비
    /// - 해당 뷰에서 사용되는 selectable member 모델로 데이터 변환
    /// - 이전 데이터 (selected members) 데이터 반영
    private func prepareSelectableMembers(with selectedMembers: [SettlementMember]) -> [SelectableSettlementMember] {
        let payerIDs = selectedMembers.filter{ $0.isPayer }.map { $0.id }
        let selectedIDs = selectedMembers.map { $0.id }
        
#warning("TODO: api 연결 후 유저 고유 id 기준으로 수정")
// 뷰모델의 members는 [WallerMember]이고 selectedMemebers는 [SettlementMember]라 id 값이 다름
// isPayer, isSelected 값이 항상 false
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
