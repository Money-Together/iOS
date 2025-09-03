//
//  CategoryListViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/13/25.
//

import Foundation
import UIKit
import Combine

final class CategoryListViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Properties
    
    var viewModel: CategoryListViewModel
    
    // MARK: Sub Views
    
    private var navigationBar: CustomNavigationBar!
    
    lazy private var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    private var addButton: CustomIconButton!
    
    // MARK: Init & Setup
    
    init(viewModel: CategoryListViewModel) {
        self.viewModel = viewModel
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
        // 카테고리 배열이 업데이트될 때
        viewModel.$categoryList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self = self else {return}
                // 변경된 카테고리 리스트로 리로드
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setUI() {
        self.view.backgroundColor = .moneyTogether.background
        
        self.addButton = CustomIconButton (
            iconImage: UIImage(named: "add"),
            iconSize: 20,
            padding: 10,
            action: {
                print(#fileID, #function, #line, "create category")
                self.viewModel.onAddBtnTapped?()
            }
        )
        
        self.navigationBar = CustomNavigationBar(
            title: "카테고리",
            rightButtons: [self.addButton],
            backBtnMode: .push,
            backAction: {
                print(#fileID, #function, #line, "back btn tapped")
                self.viewModel.onBackTapped?()
            }
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseId)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 56, right: 0)
        tableView.rowHeight = 56
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func setLayout() {
        self.view.addSubview(navigationBar)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// 카테고리 갯수 ( dataSource count)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.categoryList.count
    }
    
    // configure CategoryCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.viewModel.categoryList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseId, for: indexPath) as? CategoryCell
        cell?.configure(data)
        
        return cell ?? UITableViewCell()
    }
    
    /// cell 클릭 됐을 때 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = self.viewModel.categoryList[indexPath.row]
        
        // 수정 / 삭제 선택 액션 시트 띄우기
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 수정 액션
        let editAction = UIAlertAction(title: "수정", style: .default, handler: { _ in
            self.viewModel.handleEditButtonTap(for: selected)
        })
        
        // 삭제 액션
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.showDeleteConfirmationAlert(for: selected)
        })
        
        // 취소 액션
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [editAction, deleteAction, cancel].forEach { action in
            actionSheet.addAction(action)
        }
        
        // 띄우기
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    /// 카테고리 삭제 시 안내 alert 띄우기
    /// - Parameter id: 삭제할 자산 id
    private func showDeleteConfirmationAlert(for category: Category) {
        let alert = UIAlertController(
            title: "정말 삭제할까요?",
            message: "삭제된 카테고리는 복구할 수 없습니다. 해당 카테고리를 사용한 머니로그는 유지됩니다.",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.viewModel.handleDeleteButtonTap(for: category)
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        [deleteAction, cancel].forEach { action in
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
    
}

#Preview {
    CategoryListViewController(viewModel: CategoryListViewModel(categoryList: Category.createDummyList()))
}
