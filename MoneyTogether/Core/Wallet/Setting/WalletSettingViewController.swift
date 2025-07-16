//
//  WalletSettingViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/31/25.
//

import UIKit
import Foundation

class WalletSettingViewController: UIViewController {
    
    var viewModel: WalletViewModel
    
    // MARK: Sub Views
    
    /// 네비게이션 바
    private var navigationBar: CustomNavigationBar!
    
    /// 지갑 설정 Contents
    private var contentView: UIView!
    
    
    // MARK: Init & Set up
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
         setLayout()
    }
    
    /// view & sub views UI 설정
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        
        // 네비게이션 바
        self.navigationBar = CustomNavigationBar(
            title: "지갑 설정",
            backBtnMode: .push,
            backAction: {
                self.viewModel.onBackTapped?(.walletSetting)
            }
        )
        
        // 지갑 설정 Contents
        let hostingVC = UIHostingController(rootView: WalletSettingContentView(viewModel: viewModel))
        self.contentView = hostingVC.view.disableAutoresizingMask()
     
        self.view.addSubview(navigationBar)
        self.view.addSubview(contentView)
    }
    
    /// sub views 레이아웃 설정
    private func setLayout() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

#if DEBUG

import SwiftUI

#Preview {
    let viewModel = WalletViewModel()
    viewModel.fetchWalletData()
    viewModel.fetchMembers()
    
    return WalletSettingViewController(viewModel: viewModel)
}

#endif
