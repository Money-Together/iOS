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
    
    let viewModel: WalletHomeViewModel
    
    // MARK: Sub Views
    
    /// 지갑 프로필 뷰와 설정 버튼을 포함한 헤더 뷰
    private var headerView: UIView!
    
    /// 지갑 설정 버튼
    private var settingBtn: CustomIconButton!
    
    /// 지갑 프로필 뷰
    private var walletProfileView: UIView!
    
    private var moneylogTableView: UITableView!
    
    // MARK: Init & Set up
    
    init(viewModel: WalletHomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.fetchWalletProfile()
        self.viewModel.logsVM.fetchLogs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setBindings()
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
            let rootView = WalletProfileView(viewModel: self.viewModel.walletVM)
            
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
        
        self.moneylogTableView = UITableView().disableAutoresizingMask()
        self.setTableView()
        
    }
    
    private func setLayout() {
        self.view.addSubview(headerView)
        self.view.addSubview(moneylogTableView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            headerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            moneylogTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            moneylogTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            moneylogTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            moneylogTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
            
        ])
    }
    
    private func setBindings() {

    }
    
}

// MARK: Money Log Tabel View
extension WalletHomeViewController: UITableViewDataSource, UITableViewDelegate {

    private func setTableView() {
        self.moneylogTableView.dataSource = self
        self.moneylogTableView.delegate = self
        self.moneylogTableView.register(MoneyLogTableViewCell.self, forCellReuseIdentifier: MoneyLogTableViewCell.reuseId)
        
        self.moneylogTableView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: Layout.side, bottom: 100, trailing: Layout.side)
        self.moneylogTableView.cellLayoutMarginsFollowReadableWidth = false
        
        self.moneylogTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.moneylogTableView.separatorColor = .moneyTogether.line.normal
        self.moneylogTableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.logsVM.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.logsVM.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.logsVM.getDate(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let log = self.viewModel.logsVM.log(at: indexPath)
        
        let cell = moneylogTableView.dequeueReusableCell(withIdentifier: MoneyLogTableViewCell.reuseId, for: indexPath) as? MoneyLogTableViewCell
        cell?.configure(with: log)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = self.viewModel.logsVM.log(at: indexPath)
        print(#fileID, #function, #line, "\(log.date), \(indexPath.row + 1)th cell tapped")
    }
}


#if DEBUG

import SwiftUI

@available(iOS 17, *)
#Preview {
    WalletHomeViewController(viewModel: WalletHomeViewModel())
}


#endif
