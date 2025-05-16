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
    
    var scrollView = UIScrollView().disableAutoresizingMask()
    
    var scrollContentsView = UIView().disableAutoresizingMask()
    
    var userProfileView = UserProfileView()
    
    var userAssetTotalAmountView = UserAssetTotalAmountView()
    
    var userAssetListView = UserAssetListView()
    
    
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
        
        userProfileView.updateUI(newData: self.viewModel.profile)
        userProfileView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleProfileTap))
        )
        
        userAssetTotalAmountView.updateUI(newData: self.viewModel.userAssetTotalAmounts)
        userAssetTotalAmountView.backgroundColor = .moneyTogether.grayScale.baseGray20
        userAssetTotalAmountView.layer.cornerRadius = Radius.large
        
        userAssetListView.updateUI(newData: self.viewModel.userAssets)
        userAssetListView.backgroundColor = .moneyTogether.grayScale.baseGray20
        userAssetListView.layer.cornerRadius = Radius.large
        
        view.backgroundColor = UIColor.moneyTogether.background
    }
    
    /// components로 레이아웃 구성
    private func setLayout() {
        
        let pageTitle = UILabel.make(
            text: "My Profile",
            textColor: .moneyTogether.label.normal,
            font: .moneyTogetherFont(style: .h2),
            numberOfLines: 1
        )
        
        let assetSectionTitle = UILabel.make(
            text: "내 자산",
            textColor: .moneyTogether.label.normal,
            font: .moneyTogetherFont(style: .h4),
            numberOfLines: 1
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentsView)
        scrollContentsView.addSubview(pageTitle)
        scrollContentsView.addSubview(userProfileView)
        scrollContentsView.addSubview(assetSectionTitle)
        scrollContentsView.addSubview(userAssetTotalAmountView)
        scrollContentsView.addSubview(userAssetListView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollContentsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentsView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentsView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            pageTitle.topAnchor.constraint(equalTo: scrollContentsView.topAnchor, constant: 48),
            pageTitle.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: Layout.side),
            pageTitle.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor),
            
            userProfileView.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor),
            userProfileView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: Layout.side),
            userProfileView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 48),
            
            assetSectionTitle.topAnchor.constraint(equalTo: userProfileView.bottomAnchor, constant: 48),
            assetSectionTitle.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: Layout.side),
            assetSectionTitle.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor),
            
            userAssetTotalAmountView.topAnchor.constraint(equalTo: assetSectionTitle.bottomAnchor, constant: 12),
            userAssetTotalAmountView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: Layout.side),
            userAssetTotalAmountView.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor),
            
            userAssetListView.topAnchor.constraint(equalTo: userAssetTotalAmountView.bottomAnchor, constant: 16),
            userAssetListView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: Layout.side),
            userAssetListView.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor),
            
            userAssetListView.bottomAnchor.constraint(equalTo: scrollContentsView.bottomAnchor, constant: -56),
            
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


#if DEBUG

import SwiftUI

#Preview {
    MyPageViewController(viewModel: MyPageViewModel())
}

#endif
