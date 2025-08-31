//
//  WalletMemberListView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/1/25.
//

import Foundation
import UIKit


/// 지갑 멤버 리스트 뷰
/// - members: 보여줄 멤버 리스트
/// - onBackTapped: 멤버리스트뷰에서 뒤로가기 실행을 위한 클로져
class WalletMemberListViewController: UIViewController {
    
    // MARK:Properties
    
    /// 뒤로가기 실행 클로져
    private var onBackTapped: (() -> Void)?
    
    /// 보여줄 멤버 리스트
    private var members: [WalletMember]
    
    /// 멤버 수
    private var membersCount: Int {
        members.count
    }
    
    // MARK: Sub Views
    
    private var navigationBar: CustomNavigationBar!
    
    private var tableView: UITableView!
    
    private var inviteBtn: CTAUIButton!

    // MARK: Init & Set up
    init(members: [WalletMember], onBackTapped: (() -> Void)?) {
        self.members = members
        self.onBackTapped = onBackTapped
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
            title: "지갑멤버 (\(membersCount)명)",
            backBtnMode: .push,
            backAction: {
                self.onBackTapped?()
            }
        )
        
        self.tableView = UITableView(frame: .zero, style: .plain).disableAutoresizingMask()
        self.setTableView()
        
        self.inviteBtn = CTAUIButton(
            activeState: .active,
            buttonStyle: .solid,
            labelText: "초대하기",
            action: {
                let rootView = InviteMemberView()
                let hostingVC = UIHostingController(rootView: rootView)
                if let sheet = hostingVC.sheetPresentationController {  
                    sheet.detents = [.customFraction(0.3)]

                    sheet.largestUndimmedDetentIdentifier = .medium
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersEdgeAttachedInCompactHeight = true
                    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = false
                }
                
                self.present(hostingVC, animated: true)
                
            })
    }
    
    private func setLayout() {
        self.view.addSubview(navigationBar)
        self.view.addSubview(tableView)
        self.view.addSubview(inviteBtn)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            inviteBtn.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            inviteBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            inviteBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.side),
            inviteBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
        ])
    }
}

// MARK: Money Log Tabel View
extension WalletMemberListViewController: UITableViewDataSource, UITableViewDelegate {

    private func setTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(WalletMemberCell.self, forCellReuseIdentifier: WalletMemberCell.reuseId)
        
        tableView.rowHeight = 56 // 36 + spacing(20)
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 60, right: 0)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: Layout.side, bottom: 0, right: Layout.side)
        
        self.tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = members[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletMemberCell.reuseId, for: indexPath) as? WalletMemberCell
        cell?.configure(with: data)
        return cell ?? UITableViewCell()
    }
}


#if DEBUG

import SwiftUI

#Preview {
    let vm = WalletViewModel()
    vm.fetchMembers()
    return WalletMemberListViewController(members: vm.members, onBackTapped: {
        print(#fileID, #function, #line, "back btn tapped")
    })
}

#endif
