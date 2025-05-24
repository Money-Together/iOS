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
    
    private var scrollView = UIScrollView().disableAutoresizingMask()
    
    private var scrollContentsView = UIView().disableAutoresizingMask()
    
    private var userProfileView = UserProfileView()
    
    private var userAssetAddBtn = CustomIconButton(iconImage: UIImage(systemName: "plus"))
    
    private var userAssetTotalAmountView = UserAssetTotalAmountView()
    
    private var userAssetListView = UserAssetListView()
//    UITableView(frame: .zero, style: .insetGrouped)
    
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
        viewModel.fetchUserProfile()
        viewModel.fetchUserAssetsTotalAmounts()
        viewModel.fetchUserAssetList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    /// Sub Views, UI Components 세팅
    private func setUI() {
        view.backgroundColor = UIColor.moneyTogether.background
        
        // 유저 프로필
        userProfileView.updateUI(newData: self.viewModel.profile)
        userProfileView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleProfileTap))
        )
        
        // 유저 자산 추가 버튼
        userAssetAddBtn.setAction({
            self.viewModel.handleUserAssetAddBtnTap()
        })
        
        // 유저 자산 통화별 총 금액
        userAssetTotalAmountView.updateUI(newData: self.viewModel.userAssetTotalAmounts)
        userAssetTotalAmountView.backgroundColor = .moneyTogether.grayScale.baseGray20
        userAssetTotalAmountView.layer.cornerRadius = Radius.large
        
        // 유저 자산 리스트
//        self.setUserAssetTableView()
        userAssetListView.delegate = self
        userAssetListView.backgroundColor = .moneyTogether.grayScale.baseGray20
        userAssetListView.layer.cornerRadius = Radius.large
    }
    
    /// components로 레이아웃 구성
    private func setLayout() {
        
        let pageTitle = UILabel.make(
            text: "My Profile",
            textColor: .moneyTogether.label.normal,
            font: .moneyTogetherFont(style: .h2),
            numberOfLines: 1
        )
        
        let assetSummaryView: UIView = {
            
            let assetSectionTitle = UILabel.make(
                text: "내 자산",
                textColor: .moneyTogether.label.normal,
                font: .moneyTogetherFont(style: .h4),
                numberOfLines: 1
            )
            
            let view = UIView().disableAutoresizingMask()
            
            view.addSubview(assetSectionTitle)
            view.addSubview(userAssetAddBtn)
            view.addSubview(userAssetTotalAmountView)
            
            NSLayoutConstraint.activate([
                assetSectionTitle.topAnchor.constraint(equalTo: view.topAnchor),
                assetSectionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                assetSectionTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                userAssetAddBtn.centerYAnchor.constraint(equalTo: assetSectionTitle.centerYAnchor),
                userAssetAddBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                userAssetTotalAmountView.topAnchor.constraint(equalTo: assetSectionTitle.bottomAnchor, constant: 12),
                userAssetTotalAmountView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                userAssetTotalAmountView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                userAssetTotalAmountView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            return view
        }()
        
        let stackView = UIStackView.makeVStack(
            distribution: .fill,
            alignment: .fill,
            spacing: 48,
            subViews: [
                pageTitle, userProfileView, assetSummaryView, userAssetListView
            ])
//        stackView.backgroundColor = .gray40
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollContentsView)
        scrollContentsView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            scrollContentsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentsView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentsView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollContentsView.topAnchor, constant: 48),
            stackView.bottomAnchor.constraint(equalTo: scrollContentsView.bottomAnchor, constant: -48),
            stackView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: Layout.side),
            stackView.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor)
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
        
//        viewModel.onDeleteAsset = { [weak self] indexPath in
//            guard let self = self else { return }
//            let asset = self.viewModel.getUserAsset(at: indexPath.row)
//            self.userAssetListView.removeAssetView(assetId: asset.id)
//        }
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

extension MyPageViewController: UserAssetListViewDelegate {
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
