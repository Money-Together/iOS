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
    
    enum Section: Int, CaseIterable {
        case selected = 0
        case allMembers = 1
    }
    
    // MARK:Properties
    
    /// 뒤로가기 실행 클로져
    private var onBackTapped: (() -> Void)?
    
    /// 보여줄 멤버 리스트
    private var members: [SelectableSettlementMember]
    
    private var selectedMembers: [SelectableSettlementMember]
    
    /// 멤버 수
    private var membersCount: Int {
        members.count
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Int, SelectableSettlementMember>!
    
    // MARK: Sub Views
    
    private var navigationBar: CustomNavigationBar!
    
    private var doneBtn: CustomIconButton!
    
    private var searchBar: CustomTextField!
    
    private var payerHeaderLabel: UIView!
    
    private var settlementMemberHeaderLabel: UIView!
    
    private var allMembersSectionHeader: UIView!
    
    private var collectionView: UICollectionView!
    

    // MARK: Init & Set up
    init(members: [WalletMember], onBackTapped: (() -> Void)?) {
        self.members = members.enumerated().map{ idx, data in
            SelectableSettlementMember(id: data.id, userInfo: SimpleUser(userId: idx, nickname: data.nickname, profileImgUrl: data.profileImg), isPayer: false, isSelected: false)
        }
        self.members.prefix(10).forEach { $0.isSelected = true }
        self.selectedMembers = self.members.filter{
            $0.isPayer || $0.isSelected
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
        
        self.setupNavigationBar()
        self.setupSearchBar()
        self.setupCollectionView()
        
        self.view.addSubview(navigationBar)
//        self.view.addSubview(searchBar)
        //self.view.addSubview(tableHeaderView)
        self.view.addSubview(collectionView)
        
    }
    
    private func setLayout() {
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//            searchBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 24),
//            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.side),
//            searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
//            tableHeaderView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
//            tableHeaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.side),
//            tableHeaderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant:4),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
}

// MARK: Set Up Sub Views
extension SettlementMemberSelectionViewController {
    private func setupNavigationBar() {
        self.doneBtn = CustomIconButton(
            iconImage: UIImage(named: "circle"),
            action: {
                print(#fileID, #function, #line, "done")
            }
        )
        
        self.navigationBar = CustomNavigationBar(
            title: "지갑멤버 (\(membersCount)명)",
            rightButtons: [doneBtn],
            backBtnMode: .push,
            backAction: {
                print(#fileID, #function, #line, "뒤로가기")
                self.onBackTapped?()
            }
        )
    }
    
    private func setupSearchBar() {
        self.searchBar = CustomTextField(placeholder: "닉네임으로 검색할 수 있어요!")
        self.searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupCollectionView() {
        
        // layout
        let layout = UICollectionViewCompositionalLayout { (sectionIndex,_) -> NSCollectionLayoutSection? in
            return self.createSection(for: Section(rawValue: sectionIndex))
        }
        
        // collection view
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout).disableAutoresizingMask()
        self.collectionView.backgroundColor = .moneyTogether.background
        self.collectionView.dataSource = self
        
        // register cell
        self.collectionView.register(SelectedMemberCell.self, forCellWithReuseIdentifier: SelectedMemberCell.reuseId)
        self.collectionView.register(SettlementMemberSelectionCell.self, forCellWithReuseIdentifier: SettlementMemberSelectionCell.reuseId)
    }
    
}

// MARK: Collection View DataSource
extension SettlementMemberSelectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = Section(rawValue: section)
        switch sectionType {
        case .selected: return selectedMembers.count
        case .allMembers: return membersCount
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let section = Section(rawValue: indexPath.section)
        
        switch section {
        case .selected:
            if let cell = createSelectedMemberCell(indexPath: indexPath) {
                return cell
            }
        case .allMembers:
            if let cell = createMemberCell(indexPath: indexPath) {
                return cell
            }
        default:
            print("[❌ Error] at: \(#fileID):\(#function):\(#line) - invalid section ❌")
            return UICollectionViewCell()
        }
        
        print("[❌ Error] at: \(#fileID):\(#function):\(#line) - collection view cell casting error ❌")
        return UICollectionViewCell()
    }
}

// MARK: Collection View Layout
extension SettlementMemberSelectionViewController {
    private func createSection(for sectionType: Section?) -> NSCollectionLayoutSection {
        switch sectionType {
        case .selected:
            return createHorizontalScrollingSection()
        case .allMembers:
            return createSingleColumnSection()
        default: // error
            print("[❌ Error] at: \(#fileID):\(#function):\(#line) - invalid section ❌")
            return createSingleColumnSection()
        }
    }
    
    private func createSingleColumnSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 16
        let cellCount: CGFloat = CGFloat(membersCount)
        let cellHeight: CGFloat = 40
        let groupHeight = cellCount * cellHeight + (cellCount - 1) * spacing
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cellHeight + spacing))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(groupHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: Layout.side, bottom: 40, trailing: Layout.side)
        
        return section
    }
        
    private func createHorizontalScrollingSection() -> NSCollectionLayoutSection {
        
        let cellWidth: CGFloat = ComponentSize.verticalProfileCellSize.width
        let cellHeight: CGFloat = ComponentSize.verticalProfileCellSize.height
        
        let spacing: CGFloat = 16
        let cellCount: CGFloat = CGFloat(selectedMembers.count)
        let groupWidth: CGFloat = cellWidth * cellCount + spacing * (cellCount - 1)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cellWidth + spacing), heightDimension: .estimated(cellHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(groupWidth), heightDimension: .estimated(cellHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: Layout.side - spacing, bottom: 0, trailing: Layout.side - spacing)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
}

// MARK: Collection View Cell
extension SettlementMemberSelectionViewController {
    private func createSelectedMemberCell(indexPath: IndexPath) -> SelectedMemberCell? {
        let data = selectedMembers[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedMemberCell.reuseId, for: indexPath) as? SelectedMemberCell else {
            return nil
        }
        
        cell.configure(
            with: data,
            onDeselect: {
                print(#fileID, #function, #line, "deselect \(data.userInfo.nickname)")
            }
        )
        
        return cell
    }
    
    private func createMemberCell(indexPath: IndexPath) -> SettlementMemberSelectionCell? {
        let data = members[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettlementMemberSelectionCell.reuseId, for: indexPath) as? SettlementMemberSelectionCell else {
            return nil
        }
        
        cell.configure(
            with: data,
            onIsPayerChanged: { newValue in
                self.members[indexPath.row].isPayer = newValue
            }, onIsSelectedChanged: { newValue in
                self.members[indexPath.row].isSelected = newValue
            }
        )
        
        return cell
    }
}


extension SettlementMemberSelectionViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField == self.searchBar else { return }
        
        print(#fileID, #function, #line, "search input: \(textField.text ?? "no input")")
        
        // search action
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

