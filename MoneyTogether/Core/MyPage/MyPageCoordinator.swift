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
    /// 마이페이지 뷰모델에 있는 페이지 전환 관련 클로져 세팅
    func setVMClosures() {
        guard let root = self.rootCoordinator as? AppCoordinator else {
            return
        }
        
        // 유저 프로필 편집 버튼 클릭
        viewModel.profileEditBtnTapped = {
            let editProfileVM = EditProfileViewModel(orgData: self.viewModel.profile)
            root.showProfileEditView(viewModel: editProfileVM)
            editProfileVM.onFinishFlow = {
                root.backFromProfileEdit()
            }
        }
        
        // 유저 자산 추가 버튼 클릭
        viewModel.userAssetAddBtnTapped = {
            self.showUserAssetEditView(asset: nil, from: root)
        }
        
        // 유저 자산 수정 버튼 클릭
        viewModel.userAssetEditBtnTapped = { asset in
            self.showUserAssetEditView(asset: asset, from: root)
            print(#fileID, #function, #line, "\(asset)")
        }
        
    }
    
    /// 유저 자산 편집 뷰 띄우기
    /// - Parameters:
    ///   - asset: 편집할 자산, 새로운 자산 추가 시에는 nil
    ///   - root: 루트 네비게이션 코디네이터
    func showUserAssetEditView(asset: UserAsset?, from root: AppCoordinator) {
        var editingMode: EditingMode<UserAsset> = .create
        
        if let orgData = asset {
            editingMode = .update(orgData: orgData)
        }
        
        let editUserAssetVM = EditUserAssetViewModel(mode: editingMode)
        editUserAssetVM.onFinishFlow = { asset in
            root.backFromUserAssetEdit()
            guard let newData = asset else { return }
            
            switch editingMode {
            case .create:
                self.viewModel.onAssetAdded?(newData)
            case .update(let orgData):
                self.viewModel.onAssetUpdated?(orgData.id, newData)
            }
        }
        
        root.showUserAssetEditView(viewModel: editUserAssetVM)
    }
}

