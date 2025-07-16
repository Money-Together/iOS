//
//  WalletHomeCoordinator.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit

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
            let viewController = WalletSettingViewController(viewModel: self.viewModel.walletVM)
            self.navigationController.pushViewController(viewController, animated: true)
        }
        
        viewModel.walletVM.walletMembersPreviewTapped = { members in
            let viewController = WalletMemberListViewController(members: members, onBackTapped: { [weak self] in
                guard let self = self else { return }
                self.navigationController.popViewController(animated: true)
            })
            self.navigationController.pushViewController(viewController, animated: true)
        }
        
        viewModel.walletVM.walletEditBtnTapped = { [weak self] in
            guard let self = self,
                  let walletData = self.viewModel.walletVM.walletData else {
                return
            }
            
            let editViewModel = EditWalletProfileViewModel(mode: .update(orgData: walletData))
            editViewModel.onBackTapped = { target in
                root.navigateBack(ofType: EditWalletProfileViewController.self, animated: true)
            }
            editViewModel.onUpdated = { newValue in
                self.viewModel.walletVM.walletData = newValue
            }
            root.show(.editWalletProfile(viewModel: editViewModel))
        }
        
        viewModel.walletVM.baseCurrencyButtonTapped = { [weak self] in
            guard let self = self else { return }
            let viewController = CurrencyTypePickerViewController()
            viewController.selectedCurrency.bind({ value in
                print(#fileID, #function, #line, "selected base currency: \(value)")
            })
            self.navigationController.pushViewController(viewController, animated: true)
        }
        
        viewModel.walletVM.categoriesButtonTapped = { [weak self] in
            guard let self = self else { return }
            let viewController = CategoryListViewController(viewModel: self.viewModel.walletVM)
            self.navigationController.pushViewController(viewController, animated: true)
        }
        
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
