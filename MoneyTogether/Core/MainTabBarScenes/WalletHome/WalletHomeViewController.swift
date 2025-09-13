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
    
    private var selectedDateFilterView: SelectedDateFilterUIView!
    
    /// 머니로그 리스트 뷰
    private var moneylogTableView: UITableView!
    
    /// 새로운 머니로그 추가/생성하기 버튼
    private var addMoneylogBtn: CustomIconButton!
    
    // MARK: Init & Set up
    
    init(viewModel: WalletHomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.viewModel.fetchWalletProfile()
        //self.viewModel.logsVM.fetchLogs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.fetchWalletProfile()
        self.viewModel.logsVM.fetchLogs()
        
        setUI()
        setLayout()
        setBindings()
    }
    
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        
        self.settingBtn = CustomIconButton(
            iconImage: UIImage(named: "setting"),
            action: {
                self.viewModel.walletSettingBtnTapped?()
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
            
            // SE 시리즈 (홈버튼 없는 경우) safe area top inset = 0 -> 임의로 inset 추가
            let safeAreaTopInset = SafeAreaUtil.topInset == 0 ? 16 : SafeAreaUtil.topInset
            
            NSLayoutConstraint.activate([
                navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaTopInset),
                navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                walletProfileView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaTopInset + ComponentSize.navigationBarHeight + 8),
                walletProfileView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
                walletProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side + 4),
                walletProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            view.backgroundColor = UIColor.moneyTogether.system.blue?.withAlphaComponent(0.3)
            
            return view
        }()
        
        self.selectedDateFilterView = SelectedDateFilterUIView(viewModel: self.viewModel.logsVM)
        
        self.moneylogTableView = UITableView().disableAutoresizingMask()
        self.setTableView()
        
        self.addMoneylogBtn = CustomIconButton(
            iconImage: UIImage(named: "edit"),
            iconColor: UIColor.moneyTogether.label.rNormal,
            backgroundColor: UIColor.moneyTogether.brand.primary,
            iconSize: 24,
            padding: 16,
            cornerRadius: 20,
            action: {
                print(#fileID, #function, #line, "add new moneylog button tapped")
                self.viewModel.onAddMoneylogBtnTapped?()
            })
        
        self.view.addSubview(headerView)
        self.view.addSubview(selectedDateFilterView)
        self.view.addSubview(moneylogTableView)
        self.view.addSubview(addMoneylogBtn)
        
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            headerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            selectedDateFilterView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            selectedDateFilterView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            selectedDateFilterView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            moneylogTableView.topAnchor.constraint(equalTo: selectedDateFilterView.bottomAnchor),
            moneylogTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            moneylogTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            moneylogTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            addMoneylogBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.side),
            addMoneylogBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.side),
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
        self.moneylogTableView.register(MoneyLogCell.self, forCellReuseIdentifier: MoneyLogCell.reuseId)
        self.moneylogTableView.register(MoneyLogDateCell.self, forCellReuseIdentifier: MoneyLogDateCell.reuseId)
        
        self.moneylogTableView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: Layout.side, bottom: 100, trailing: Layout.side)
        self.moneylogTableView.cellLayoutMarginsFollowReadableWidth = false
        
        self.moneylogTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.moneylogTableView.separatorColor = .moneyTogether.line.normal
        self.moneylogTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.logsVM.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellItem = viewModel.logsVM.cellItem(at: indexPath)
        
        switch cellItem {
        case .date(let dateString):
            let cell = moneylogTableView.dequeueReusableCell(withIdentifier: MoneyLogDateCell.reuseId, for: indexPath) as? MoneyLogDateCell
            cell?.configure(with: dateString)
            return cell ?? UITableViewCell()
        case .moneyLog(let moneyLog):
            let cell = moneylogTableView.dequeueReusableCell(withIdentifier: MoneyLogCell.reuseId, for: indexPath) as? MoneyLogCell
            cell?.configure(with: moneyLog)
            return cell ?? UITableViewCell()
        }
        
    }
    
    /// 테이블 뷰 cell 클릭 시 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellItem = viewModel.logsVM.cellItem(at: indexPath)
        
        switch cellItem {
        case .date: // 날짜 헤더 cell일 경우 액션 없음
            return
        case .moneyLog(let moneyLog):
            print(#fileID, #function, #line, "\(moneyLog.date), \(indexPath.row + 1)th cell tapped")
        }  
    }
}


#if DEBUG

import SwiftUI

@available(iOS 17, *)
#Preview {
    WalletHomeViewController(viewModel: WalletHomeViewModel())
}


#endif
