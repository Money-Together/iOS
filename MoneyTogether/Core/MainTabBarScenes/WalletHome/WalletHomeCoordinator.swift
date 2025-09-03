//
//  WalletHomeCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit
import SwiftUI

enum WalletHomeRouteTarget {
    case walletSetting
    case walletMemberList
    case editWallet
    case baseCurrency
    case categoryList
}

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
        setWalletVMClosures()
        self.navigationController.viewControllers = [WalletHomeViewController(viewModel: viewModel)]
    }
}

extension WalletHomeCoordinator {
    /// 지갑 홈 뷰모델에 있는 페이지 전환 관련 클로져 세팅
    func setVMClosures() {
        guard let root = self.rootCoordinator as? AppCoordinator else {
            return
        }
        
        // 머니로그 생성 버튼 클릭 시
        // 편집 플로우 코디네이터 추가 & 플로우 네비게이션컨트롤러 present
        viewModel.onAddMoneylogBtnTapped = { [weak self] in
            guard let self = self else { return }
            
            let editMoneylogCoordinator = EditMoneyLogCoordinator(
                parentCoordinator: self,
                walletData: self.viewModel.walletVM.walletData!,
                walletMembers: self.viewModel.walletVM.members
            )
            editMoneylogCoordinator.start()
            self.children.append(editMoneylogCoordinator)
            
            let childNav = editMoneylogCoordinator.navigationController
            childNav.modalPresentationStyle = .overFullScreen
            self.navigationController.present(childNav, animated: true)
        }
        
        // 지갑 설정 화면 이동
        viewModel.walletSettingBtnTapped = { [weak self] in
            guard let self = self else { return }
            let viewController = WalletSettingViewController(viewModel: self.viewModel.walletVM)
            self.navigationController.pushViewController(viewController, animated: true)
        }
        
    }
    
    private func setWalletVMClosures() {
        guard let root = self.rootCoordinator as? AppCoordinator else {
            return
        }
        
        // 지갑 프로필 편집 화면으로 이동
        viewModel.walletVM.walletEditBtnTapped = { [weak self] in
            guard let self = self else { return }
            self.naviagateToEditWalletProfileView()
        }
        
        // 지갑 멤버 리스트 화면으로 이동
        viewModel.walletVM.walletMembersPreviewTapped = { members in
            self.navigateToWalletMemberList(members: members)
        }
        
        // 기본 통화 선택 화면으로 이동
        viewModel.walletVM.baseCurrencyButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToBaseCurrencyPicker()
        }
        
        // 카테고리 리스트 화면으로 이동
        viewModel.walletVM.categoriesButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToCategoryList()
        }
        
        // 뒤로가기
        viewModel.walletVM.onBackTapped = { target in
            switch target {
            case .walletSetting:
                self.navigateBack(ofType: WalletSettingViewController.self, animated: true)
//            case .walletMemberList:
//                self.navigateBack(ofType: WalletMemberListViewController.self, animated: true)
            case .editWallet:
                root.navigateBack(ofType: EditWalletProfileViewController.self, animated: true)
            case .baseCurrency:
                self.navigateBack(ofType: CurrencyTypePickerViewController.self)
            case .categoryList:
                self.navigateBack(ofType: CategoryListViewController.self)
            default: return
            }
        }
    }
}

// MARK: Wallet Setting

extension WalletHomeCoordinator {
    
    /// 지갑 프로필 편집 화면으로 이동
    private func naviagateToEditWalletProfileView() {
        guard let root = self.rootCoordinator as? AppCoordinator else { return }
        
        guard let walletData = self.viewModel.walletVM.walletData else { return }
        
        let editViewModel = EditWalletProfileViewModel(mode: .update(orgData: walletData))
        editViewModel.onBackTapped = { _ in // 뒤로가기 (편집화면 -> 지갑 설정 뷰)
            root.navigateBack(ofType: EditWalletProfileViewController.self, animated: true)
        }
        editViewModel.onUpdated = { newValue in // 편집 완료
            self.viewModel.walletVM.walletData = newValue
        }
        
        root.show(.editWalletProfile(viewModel: editViewModel))
    }
    
    /// 지갑 멤버 리스트 화면으로 이동
    private func navigateToWalletMemberList(members: [WalletMember]) {
        let viewController = WalletMemberListViewController(
            members: members,
            onBackTapped: { [weak self] in // 뒤로가기
                guard let self = self else { return }
                self.navigateBack(ofType: WalletMemberListViewController.self)
            }
        )
        self.show(viewController, animated: true)
    }
    
    /// 기본 통화 선택 화면으로 이동
    private func navigateToBaseCurrencyPicker() {
        let viewController = CurrencyTypePickerViewController()
        viewController.selectedCurrency.bind({ value in
            print(#fileID, #function, #line, "selected base currency: \(value)")
        })
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    /// 카테고리 리스트 화면으로 이동
    private func navigateToCategoryList() {
        // 카테고리 리스트 뷰모델
        let viewModel = CategoryListViewModel(categoryList: self.viewModel.walletVM.categories)
        viewModel.onBackTapped = { // 뒤로가기 (리스트 -> 지갑 설정)
            self.navigateBack(ofType: CategoryListViewController.self, animated: true)
        }
        viewModel.onAddBtnTapped = { // 카테고리 추가
            self.navigateToEditCategoryView(mode: .create, listViewModel: viewModel)
        }
        viewModel.onUpdateBtnTapped = { category in // 카테고리 수정
            self.navigateToEditCategoryView(mode: .update(orgData: category), listViewModel: viewModel)
        }
        
        let viewController = CategoryListViewController(viewModel: viewModel)
        self.show(viewController, animated: true)
    }
    
    /// 카테고리 편집 화면으로 이동
    private func navigateToEditCategoryView(mode: EditingMode<Category>, listViewModel: CategoryListViewModel) {
        guard let root = self.rootCoordinator as? AppCoordinator else { return }
        
        let editViewModel = EditCategoryViewModel(mode: mode)
        editViewModel.onBack = { // 뒤로가기 (카테고리 편집 -> 카테고리 리스트)
            root.navigationController.popViewController(animated: true)
        }
        editViewModel.onDone = { mode, newValue in // 편집 완료
            switch mode {
            case .create:
                listViewModel.addCategory(newValue)
            case .update(let id):
                listViewModel.updateCategory(of: id, newValue)
            }
            DispatchQueue.main.async {
                root.navigationController.popViewController(animated: true)
            }
        }
        editViewModel.onSelectColor = { // 컬러 선택 모달 띄우기
            self.presentCategoryColorSelection(editViewModel: editViewModel)
        }
        editViewModel.onSelectIcon = { // 아이콘 선택 모달 띄우기
            self.presentCategoryIconSelection(editViewModel: editViewModel)
        }
        
        let editView = EditCategoryView(viewModel: editViewModel)
        let hostingVC = UIHostingController(rootView: editView)
        
        root.show(hostingVC, animated: true)
    }
    
    /// 카테고리 색상 선택 모달 띄우기
    private func presentCategoryColorSelection(editViewModel: EditCategoryViewModel) {
        let viewController = ColorSelectionViewController()
        viewController.onSelect = { newValue in
            editViewModel.updateColor(newValue)
        }
        self.navigationController.showSheet(viewController: viewController, detents: [.fixedHeight(400), .customFraction(0.99)])
    }
    
    /// 카테고리 아이콘 선택 모달 띄우기
    private func presentCategoryIconSelection(editViewModel: EditCategoryViewModel) {
        let viewController = IconSelectionViewController()
        viewController.onSelect = { newValue in
            editViewModel.updateIcon(newValue)
        }
        self.navigationController.showSheet(viewController: viewController, detents: [.fixedHeight(400), .customFraction(0.99)])
    }
}

