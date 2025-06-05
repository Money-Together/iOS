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
    
    private var navigationBar: CustomNavigationBar!
    
    private var walletProfileEditBtn: CustomIconButton!
    
    private var walletProfileView: UIView!
    
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
    
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        
        self.navigationBar = CustomNavigationBar(
            title: "지갑 설정",
            backBtnMode: .push,
            backAction: {
                self.viewModel.onBackTapped?(.walletSetting)
            }
        )
        
        self.walletProfileEditBtn = CustomIconButton(
            iconImage: UIImage(named: "more_horiz"),
            action: {
                print(#fileID, #function, #line, "navigate to wallet profile edit page")
                self.viewModel.walletEditBtnTapped?()
            })
        
        self.walletProfileView = {
            let rootView = WalletProfileSettingsView(viewModel: self.viewModel)
            let hostingVC = UIHostingController(rootView: rootView)
            let uiView = hostingVC.view.disableAutoresizingMask()
            
            uiView.backgroundColor = .clear
            
            return uiView
        }()
        
    }
    
    private func setLayout() {
        self.view.addSubview(navigationBar)
        self.view.addSubview(walletProfileView)
        self.view.addSubview(walletProfileEditBtn)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            walletProfileView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 8),
            walletProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            walletProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            walletProfileEditBtn.topAnchor.constraint(equalTo: walletProfileView.topAnchor, constant: 8),
            walletProfileEditBtn.trailingAnchor.constraint(equalTo: walletProfileView.trailingAnchor, constant: -8),
            
            
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
