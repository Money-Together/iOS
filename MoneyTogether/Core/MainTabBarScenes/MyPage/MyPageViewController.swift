//
//  MyPageViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit


/// 마이페이지 뷰
class MyPageViewController: UIViewController {
    
    var viewModel: MyPageViewModel
    
    
    // MARK: Sub Views
    
    private var navigationBar : CustomNavigationBar!
    
    private var scrollView = UIScrollView().disableAutoresizingMask()
    
    private var scrollContentsView = UIView().disableAutoresizingMask()
    
    private var userProfileView = UserProfileView()
    
    private var userAssetAddBtn: CustomIconButton!
    
    private var userAssetTotalAmountView = UserAssetTotalAmountView()
    
    private var userAssetListView = UserAssetListView()
    
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        viewModel.fetchUserProfile()
//        viewModel.fetchUserAssetsTotalAmounts()
//        viewModel.fetchUserAssetList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        
        bindViewModel()
        viewModel.fetchUserProfile()
        viewModel.fetchUserAssetsTotalAmounts()
        viewModel.fetchUserAssetList()
    }
    
    /// Sub Views, UI Components 세팅
    private func setUI() {
        view.backgroundColor = UIColor.moneyTogether.background
        
        let settingButton = CustomIconButton(
            iconImage: UIImage(named: "setting"),
            action: {
                print(#fileID, #function, #line, "setting")
                self.viewModel.settingBtnTapped?()
            }
        )
        
        self.navigationBar = CustomNavigationBar(
            title: "",
            backgroundColor: .moneyTogether.background,
            rightButtons: [settingButton]
        )
        
        // 유저 프로필
        userProfileView.updateUI(newData: self.viewModel.profile)
        userProfileView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleProfileTap))
        )
        let _ = userProfileView.applyCardStyle()

        // 유저 자산 추가 버튼
        userAssetAddBtn = CustomIconButton(
            iconImage: UIImage(named: "add"),
            iconSize: 16,
            padding: 16,
            action: {
                self.viewModel.handleUserAssetAddBtnTap()
            }
        )
        
        // 유저 자산 통화별 총 금액
        userAssetTotalAmountView.updateUI(newData: self.viewModel.userAssetTotalAmounts)
        let _ = userAssetTotalAmountView.applyCardStyle(horizontalPadding: 0, verticalPadding: 0)
        
        
        // 유저 자산 리스트
        userAssetListView.delegate = self
        let _ = userAssetListView.applyCardStyle()
    }
    
    /// components로 레이아웃 구성
    private func setLayout() {
    
        let assetSummaryView = SectionCardUIView(
            title: "내 자산",
            content: { self.userAssetTotalAmountView }
        )
        assetSummaryView.addSubview(userAssetAddBtn)
        NSLayoutConstraint.activate([
            userAssetAddBtn.topAnchor.constraint(equalTo: assetSummaryView.topAnchor, constant: -12),
            userAssetAddBtn.trailingAnchor.constraint(equalTo: assetSummaryView.trailingAnchor, constant: 4)
        ])
        
        let assetStackView = UIStackView.makeVStack(
            distribution: .fill,
            alignment: .fill,
            spacing: 24,
            subViews: [
                assetSummaryView,
                userAssetListView
            ]
        )
        
        scrollContentsView.layoutMargins = UIEdgeInsets(top: ComponentSize.navigationBarHeight + 12, left: Layout.side, bottom: Layout.bottom, right: Layout.side)
        
        self.view.addSubview(scrollView)
        self.view.addSubview(navigationBar)
        scrollView.addSubview(scrollContentsView)
        scrollContentsView.addSubview(userProfileView)
        scrollContentsView.addSubview(assetStackView)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            scrollContentsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentsView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentsView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            userProfileView.topAnchor.constraint(equalTo: scrollContentsView.layoutMarginsGuide.topAnchor),
            userProfileView.leadingAnchor.constraint(equalTo: scrollContentsView.layoutMarginsGuide.leadingAnchor),
            userProfileView.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor),
            
            assetStackView.topAnchor.constraint(equalTo: userProfileView.bottomAnchor, constant: 48),
            assetStackView.bottomAnchor.constraint(equalTo: scrollContentsView.layoutMarginsGuide.bottomAnchor),
            assetStackView.leadingAnchor.constraint(equalTo: scrollContentsView.layoutMarginsGuide.leadingAnchor),
            assetStackView.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor)
        ])
        
    }
    
    /// 바인딩 처리
    private func bindViewModel() {
        viewModel.onProfileUpdated = { [weak self] in
            guard let self = self else { return }
            self.userProfileView.updateUI(newData: self.viewModel.profile)
        }
        
        viewModel.onUserAssetTotalAmountsUpdated = { [weak self] in
            guard let self = self else { return }
            self.userAssetTotalAmountView.updateUI(newData: self.viewModel.userAssetTotalAmounts)
        }
        
        viewModel.onUserAssetsUpdated = { [weak self] in
            guard let self = self else { return }
            self.userAssetListView.updateUI(newData: self.viewModel.userAssets)
        }
        
        viewModel.onAssetAdded = { [weak self] newAsset in
            guard let self = self else { return }
            self.userAssetListView.addAssetRow(asset: newAsset)
            self.viewModel.addUserAsset(asset: newAsset)
        }
        
        viewModel.onAssetUpdated = { [weak self] id, newAsset in
            guard let self = self else { return }
            self.userAssetListView.updateAssetRow(assetId: id, newData: newAsset)
            self.viewModel.updateUserAsset(for: id, asset: newAsset)
        }
    }
}

// MARK: Action
extension MyPageViewController {
    @objc func handleProfileTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print(#fileID, #function, #line, "프로필 탭")
            self.viewModel.handleProfileEditBtnTap()
        }
    }
}

// MARK:
extension MyPageViewController: UserAssetListViewDelegate {
    /// 자산 리스트에서 row 클릭 시 호출
    /// 수정/삭제 액션 시트 띄우기
    /// - Parameters:
    ///   - listView: 자산 리스트 뷰
    ///   - id: 클릭된 자산 id
    func assetListView(_ listView: UserAssetListView, didTapAsset id: UUID) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정", style: .default, handler: { _ in
            self.viewModel.handleUserAssetEditBtnTap(for: id)
        })
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.showAssetDeleteConfirmationAlert(for: id)
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [editAction, deleteAction, cancel].forEach { action in
            actionSheet.addAction(action)
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    /// 자산 삭제 시 안내 alert 띄우기
    /// - Parameter id: 삭제할 자산 id
    private func showAssetDeleteConfirmationAlert(for id: UUID) {
        let alert = UIAlertController(
            title: "정말 삭제할까요?",
            message: "삭제된 자산은 복구할 수 없습니다.",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.viewModel.deleteUserAsset(for: id)
            // success
            self.userAssetListView.removeAssetView(assetId: id)
            
            // fail
//             self.showErrorAlert(title: "자산 삭제를 실패하였습니다.")
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        [deleteAction, cancel].forEach { action in
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
}


#if DEBUG

import SwiftUI

#Preview {
    MyPageViewController(viewModel: MyPageViewModel())
}

#endif
