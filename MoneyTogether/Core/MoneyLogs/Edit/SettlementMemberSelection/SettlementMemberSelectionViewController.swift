//
//  SettlementMemberSelectionViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/26/25.
//

import Foundation
import UIKit
import Combine

/// 정산 멤버 선택을 위한 멤버 리스트 뷰
/// - members: 보여줄 멤버 리스트, 정산멤버 선택을 위한 데이터 포함
/// - onBackTapped: 멤버리스트뷰에서 뒤로가기 실행을 위한 클로져
class SettlementMemberSelectionViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case selected = 0
        case allMembers = 1
    }
    
    typealias Member = SelectableSettlementMember
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK:Properties
    
    private var viewModel: SettlementMemberSelectionViewModel
    
    /// 뒤로가기 실행 클로져
    private var onBackTapped: (() -> Void)?
    
    /// 완료 실행 클로져
    private var onDoneTapped: (([SettlementMember]) -> Void)?
    
    /// 보여줄 멤버 리스트
    private var members: [Member] {
        viewModel.displayedMembers
    }
    
    private var selectedMembers: [Member] {
        viewModel.selectedMembers
    }
    
    /// 멤버 수
    private var membersCount: Int {
        members.count
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Int, SelectableSettlementMember>!
    
    private var selectedMembersViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: Sub Views
    
    private var navigationBar: CustomNavigationBar!
    
    private var doneBtn: CustomIconButton!
    
    private var searchBar: CustomTextField!
    
    private var settlementMemberHeaderLabel: UIView!
    
    private var allMembersSectionHeader: UIView!
    
    private var selectedMemberListView: UICollectionView!
    
    private var memberListView: UICollectionView!
    

    // MARK: Init & Set up
    init(members: [WalletMember],
         onBackTapped: (() -> Void)?,
         onDoneTapped: (([SettlementMember]) -> Void)?) {
        self.viewModel = SettlementMemberSelectionViewModel(members: members)
        
        self.onBackTapped = onBackTapped
        self.onDoneTapped = onDoneTapped
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        setUI()
        setLayout()
    }
    
    private func setBindings() {
        // members 배열이 업데이트될 때
        viewModel.$displayedMembers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] members in
                guard let self = self else {return}
                // 변경된 멤버 리스트로 리로드
                self.memberListView.reloadData()
            }
            .store(in: &cancellables)
        
    }
    
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        
        self.setupNavigationBar()
        self.setupSearchBar()
        self.setupSelectedMemberListView()
        self.setupMemberListView()
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(selectedMemberListView)
        self.view.addSubview(searchBar)
        self.view.addSubview(memberListView)
        
    }
    
    private func setLayout() {
        
        let checkboxDescriptionLabel: UIView = {
            let view = UIView().disableAutoresizingMask()

            let payerLabel = UILabel.make(
                text: "결제",
                textColor: .moneyTogether.label.assistive,
                font: .moneyTogetherFont(style: .detail2)
            )
            payerLabel.textAlignment = .center
            
            let participantLabel = UILabel.make(
                text: "함께",
                textColor: .moneyTogether.label.assistive,
                font: .moneyTogetherFont(style: .detail2)
            )
            participantLabel.textAlignment = .center
            
            view.addSubview(payerLabel)
            view.addSubview(participantLabel)
            
            NSLayoutConstraint.activate([
                payerLabel.widthAnchor.constraint(equalToConstant: 40),
                participantLabel.widthAnchor.constraint(equalToConstant: 40),
                
                payerLabel.topAnchor.constraint(equalTo: view.topAnchor),
                payerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                participantLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                participantLabel.topAnchor.constraint(equalTo: view.topAnchor),
                
                participantLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                participantLabel.leadingAnchor.constraint(equalTo: payerLabel.trailingAnchor, constant: 8),
            ])
            
            return view
        }()
        
        self.view.addSubview(checkboxDescriptionLabel)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            selectedMemberListView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 12),
            selectedMemberListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            selectedMemberListView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            searchBar.topAnchor.constraint(equalTo: selectedMemberListView.bottomAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.side),
            searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            checkboxDescriptionLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            checkboxDescriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.side),
            checkboxDescriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            memberListView.topAnchor.constraint(equalTo: checkboxDescriptionLabel.bottomAnchor, constant:4),
            memberListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            memberListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberListView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
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
    
    private func setupSelectedMemberListView() {
        
        // layout
        let layout = UICollectionViewCompositionalLayout { (_,_) -> NSCollectionLayoutSection? in
            return self.createHorizontalScrollingSection()
        }
        
        // collection view
        self.selectedMemberListView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout).disableAutoresizingMask()
        self.selectedMemberListView.backgroundColor = .moneyTogether.background
        self.selectedMemberListView.dataSource = self
        
        // register cell
        self.selectedMemberListView.register(SelectedMemberCell.self, forCellWithReuseIdentifier: SelectedMemberCell.reuseId)
        
        // colection view height constraint
        self.selectedMembersViewHeightConstraint = self.selectedMemberListView.heightAnchor.constraint(equalToConstant: selectedMembers.isEmpty ? 0 : ComponentSize.verticalProfileCellSize.height)
        self.selectedMembersViewHeightConstraint.isActive = true
        
    }
    
    private func setupMemberListView() {
        
        // layout
        let layout = UICollectionViewCompositionalLayout { (_,_) -> NSCollectionLayoutSection? in
            return self.createSingleColumnSection()
        }
        
        // collection view
        self.memberListView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout).disableAutoresizingMask()
        self.memberListView.backgroundColor = .moneyTogether.background
        self.memberListView.dataSource = self
        
        // register cell
        self.memberListView.register(SettlementMemberSelectionCell.self, forCellWithReuseIdentifier: SettlementMemberSelectionCell.reuseId)
    }
    
    private func updateSelectedMembersViewHeight(animated: Bool = true) {
        let hasSelectedMembers = !self.selectedMembers.isEmpty
        let height: CGFloat = hasSelectedMembers ? ComponentSize.verticalProfileCellSize.height : 0
        
        guard selectedMembersViewHeightConstraint.constant != height else {
            return
        }
        
        selectedMembersViewHeightConstraint.constant = height
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: Collection View DataSource
extension SettlementMemberSelectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case selectedMemberListView: return selectedMembers.count
        case memberListView: return membersCount
        default:
            print("[❌ Error] at: \(#fileID):\(#function):\(#line) - invalid collection view ❌")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        case selectedMemberListView:
            if let cell = createSelectedMemberCell(indexPath: indexPath) {
                return cell
            }
        case memberListView:
            if let cell = createMemberCell(indexPath: indexPath) {
                return cell
            }
        default:
            print("[❌ Error] at: \(#fileID):\(#function):\(#line) - invalid collection view ❌")
            return UICollectionViewCell()
        }
        
        print("[❌ Error] at: \(#fileID):\(#function):\(#line) - collection view cell casting error ❌")
        return UICollectionViewCell()
    }
}

// MARK: Collection View Layout
extension SettlementMemberSelectionViewController {

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
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: Layout.side, bottom: 40, trailing: Layout.side)
        
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
        
        guard let cell = selectedMemberListView.dequeueReusableCell(withReuseIdentifier: SelectedMemberCell.reuseId, for: indexPath) as? SelectedMemberCell else {
            return nil
        }
        
        cell.configure(
            with: data,
            onDeselect: {
                self.handleSelectedMemberDeletion(id: data.id)
            }
        )
        
        return cell
    }
    
    private func createMemberCell(indexPath: IndexPath) -> SettlementMemberSelectionCell? {
        let data = members[indexPath.row]
        
        guard let cell = memberListView.dequeueReusableCell(withReuseIdentifier: SettlementMemberSelectionCell.reuseId, for: indexPath) as? SettlementMemberSelectionCell else {
            return nil
        }
        
        cell.configure(
            with: data,
            onIsPayerChanged: { isPayer in
                self.handlePayerSelectionChange(id: data.id, isPayer: isPayer)
            }, onIsSelectedChanged: { isSelected in
                self.handleMemberSelectionChange(id: data.id, isSelected: isSelected)
            }
        )
        
        return cell
    }
}

// MARK: isSelected/isPayer Change Handler
extension SettlementMemberSelectionViewController {
    
    /// 정산 멤버 선택 / 해제 처리
    /// - 뷰모델에서 데이터 처리
    /// - selected member list view UI 업데이트
    func handleMemberSelectionChange(id: UUID, isSelected: Bool) {
        if isSelected {
            // 뷰모델에서 멤버 선택 처리
            viewModel.selectMember(id: id)
            
            // selected member list에 아이템 추가 (항상 첫 번째 위치에 추가)
            let indexPath = IndexPath(item: 0, section: 0)
            selectedMemberListView.insertItems(at: [indexPath])
            
            // selected member list view 높이 업데이트
            // 선택된 멤버가 없을 경우, 리스트뷰가 보이지 않게 높이 0으로 설정됨
            if !selectedMembers.isEmpty {
                updateSelectedMembersViewHeight()
            }
        } else {
            // selected member list에 해당 멤버가 포함되어 있을 경우
            if let index = viewModel.getIndexOfSelectedMember(id: id) {
                // 뷰모델에서 멤버 선택 해제 처리
                viewModel.deselectMember(id: id)
                
                // selected member list에서 아이템 삭제
                let indexPath = IndexPath(item: index, section: 0)
                selectedMemberListView.deleteItems(at: [indexPath])
                
                // selected member list view 높이 업데이트
                // 선택된 멤버가 없을 경우, 리스트뷰가 보이지 않게 높이 0으로 설정됨
                if selectedMembers.isEmpty {
                    updateSelectedMembersViewHeight()
                }
            }
        }
    }
    
    
    /// 결제자 선택 / 해제 처리
    /// - 뷰모델에서 데이터 처리
    /// - selected member list의 cell UI 업데이트
    func handlePayerSelectionChange(id: UUID, isPayer: Bool) {
        // 뷰모델에서 데이터 처리
        self.viewModel.setPayer(isPayer, for: id)
        
        // update selected member cell
        // payer 마크 추가 / 제거
        if let index = viewModel.getIndexOfSelectedMember(id: id) {
            let indexPath = IndexPath(item: index, section: 0)
            selectedMemberListView.reloadItems(at: [indexPath])
        }
    }
    
    /// 선택된 멤버 삭제 처리
    /// selected member list view에서 cell에 있는 삭제 버튼 클릭 시
    /// - 선택 해제 처리
    /// - memer list view의 cell의 체크박스 UI 업데이트
    func handleSelectedMemberDeletion(id: UUID) {
        // 선택 해제
        self.handleMemberSelectionChange(id: id, isSelected: false)
        
        // member list view에서 해당 멤버 cell UI 업데이트
        if let index = self.viewModel.getIndexOfMember(id: id) {
            let indexPath = IndexPath(item: index, section: 0)
            self.memberListView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: Search
extension SettlementMemberSelectionViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField == self.searchBar else { return }
        
        // if no input, all members are displayed
        guard let input = textField.text,
              input != "" else {
            self.viewModel.initDisplayedMembers()
            return
        }
        
        // search action
        self.viewModel.updateDisplayedMembers(with: input)
    }
}


//#if DEBUG
//
//import SwiftUI
//
//#Preview {
//    let vm = WalletViewModel()
//    vm.fetchMembers()
//    return SettlementMemberSelectionViewController(members: vm.members, onBackTapped: {
//        print(#fileID, #function, #line, "back btn tapped")
//    })
//}
//
//#endif

