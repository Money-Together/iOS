//
//  EditMoneyLogViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/24/25.
//

import Foundation
import UIKit


class EditMoneyLogViewController: UIViewController {
    
    var viewModel: EditMoneyLogViewModel
    
    // MARK: Sub Views
    
    /// 네비게이션 바
    private var navigationBar: CustomNavigationBar!
    
    /// scroll view
    private var scrollView: UIScrollView!
    
    /// scroll view contents
    private var contentView: UIView!
    
    init(viewModel: EditMoneyLogViewModel) {
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
            title: "",
            backBtnMode: .modal,
            backAction: {
                print(#fileID, #function, #line, "뒤로가기")
                self.viewModel.onBackTapped?()
            }
        )
        
        // 스크롤뷰
        self.scrollView = UIScrollView().disableAutoresizingMask()
        
        // 지갑 설정 Contents
        let hostingVC = UIHostingController(rootView: EditMoneyLogContentView())
        self.contentView = hostingVC.view.disableAutoresizingMask()
     
        self.scrollView.addSubview(contentView)
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(scrollView)
        
    }
    
    /// sub views 레이아웃 설정
    private func setLayout() {

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
}

#if DEBUG

import SwiftUI

#Preview {
    let vm = WalletViewModel()
    vm.fetchWalletData()
    vm.fetchMembers()
    
    return EditMoneyLogViewController(viewModel: EditMoneyLogViewModel(walletData: vm.walletData!, walletMembers: vm.members))
}

#endif
