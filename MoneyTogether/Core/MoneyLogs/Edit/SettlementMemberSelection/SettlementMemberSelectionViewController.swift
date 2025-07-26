//
//  SettlementMemberSelectionViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/26/25.
//

import Foundation
import UIKit

/// 정산 멤버 선택을 위한 멤버 리스트 뷰
/// - members: 보여줄 멤버 리스트, 정산멤버 선택을 위한 데이터 포함
/// - onBackTapped: 멤버리스트뷰에서 뒤로가기 실행을 위한 클로져
class SettlementMemberSelectionViewController: UIViewController {
    
    enum TableViewSection {
        case main
    }
    
    // MARK:Properties
    
    /// 뒤로가기 실행 클로져
    private var onBackTapped: (() -> Void)?
    
    /// 보여줄 멤버 리스트
    private var members: [SelectableSettlementMember]
    
    /// 멤버 수
    private var membersCount: Int {
        members.count
    }
    
    var dataSource: UITableViewDiffableDataSource<TableViewSection, SelectableSettlementMember>!
    
    // MARK: Sub Views
    
    private var navigationBar: CustomNavigationBar!
    
    private var doneBtn: CustomIconButton!
    
    private var tableView: UITableView!
    

    // MARK: Init & Set up
    init(members: [WalletMember], onBackTapped: (() -> Void)?) {
        self.members = members.map{
            SelectableSettlementMember(id: $0.id, userInfo: SimpleUser(userId: 1, nickname: $0.nickname, profileImgUrl: $0.profileImg), isPayer: false, isSelected: false)
        }
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
        
        self.doneBtn = CustomIconButton(
            iconImage: UIImage(named: ""),
            action: {
                print(#fileID, #function, #line, "done")
            })
        
        self.navigationBar = CustomNavigationBar(
            title: "지갑멤버 (\(membersCount)명)",
            rightButtons: [doneBtn],
            backBtnMode: .push,
            backAction: {
                print(#fileID, #function, #line, "뒤로가기")
                self.onBackTapped?()
            }
        )
        
        self.tableView = UITableView(frame: .zero, style: .plain).disableAutoresizingMask()
        self.setupTableView()
    }
    
    private func setLayout() {
        self.view.addSubview(navigationBar)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
}


// MARK: Set Up Table View
extension SettlementMemberSelectionViewController {

    private func setupTableView() {
        
        // register cell
        self.tableView.register(SettlementMemberSelectionCell.self, forCellReuseIdentifier: SettlementMemberSelectionCell.reuseId)
        
        // dataSource
        self.setupDataSource()
        self.tableView.dataSource = dataSource
        
        // init snapshot & load initial data
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, SelectableSettlementMember>()
        snapshot.appendSections([.main])
        snapshot.appendItems(members)
        dataSource.apply(snapshot)
        
        // tableView layout
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 60, right: 0)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: Layout.side, bottom: 0, right: Layout.side)
        
        self.tableView.separatorStyle = .none
    }
    
    private func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource<TableViewSection, SelectableSettlementMember>(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let data = self.members[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SettlementMemberSelectionCell.reuseId, for: indexPath) as? SettlementMemberSelectionCell
            cell?.configure(
                with: data,
                onIsPayerChanged: { newValue in
                    self.members[indexPath.row].isPayer = newValue
                }, onIsSelectedChanged: { newValue in
                    self.members[indexPath.row].isSelected = newValue
                }
            )
            
            return cell ?? UITableViewCell()
        })
    }
}


#if DEBUG

import SwiftUI

#Preview {
    let vm = WalletViewModel()
    vm.fetchMembers()
    return SettlementMemberSelectionViewController(members: vm.members, onBackTapped: {
        print(#fileID, #function, #line, "back btn tapped")
    })
}

#endif

