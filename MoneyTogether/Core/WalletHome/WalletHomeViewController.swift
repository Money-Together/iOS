//
//  WalletHomeViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit
import SwiftUI


/// 지갑 홈 뷰
class WalletHomeViewController: UIViewController {
    
    // MARK: Sub Views
    
    /// 지갑 프로필 뷰와 설정 버튼을 포함한 헤더 뷰
    private var headerView: UIView!
    
    /// 지갑 설정 버튼
    private var settingBtn: CustomIconButton!
    
    /// 지갑 프로필 뷰
    private var walletProfileView: UIView!
    
    // MARK: Init & Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        
        self.settingBtn = CustomIconButton(
            iconImage: UIImage(named: "setting"),
            action: {
                print(#fileID, #function, #line, "navigate to wallet setting page")
            })
        
        let navigationBar = CustomNavigationBar(rightButtons: [settingBtn])
        
        self.walletProfileView = {
            let rootView = WalletProfileView(wallet: Wallet.createDummyData())
            
            let hostingVC = UIHostingController(rootView: rootView)
            let uiView = hostingVC.view.disableAutoresizingMask()
            
            uiView.backgroundColor = .clear
            
            return uiView
        }()
        
        self.headerView = {
            let view = UIView().disableAutoresizingMask()
            
            view.addSubview(navigationBar)
            view.addSubview(self.walletProfileView)
            
            NSLayoutConstraint.activate([
                navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: SafeAreaUtil.topInset),
                navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                walletProfileView.topAnchor.constraint(equalTo: view.topAnchor, constant: SafeAreaUtil.topInset + ComponentSize.navigationBarHeight + 8),
                walletProfileView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
                walletProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side + 4),
                walletProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            view.backgroundColor = UIColor.moneyTogether.system.blue?.withAlphaComponent(0.3)
            
            return view
        }()
        
    }
    
    private func setLayout() {
        self.view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            headerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
    }
}


#if DEBUG

import SwiftUI

@available(iOS 17, *)
#Preview {
    return WalletHomeViewController()
}


#endif
