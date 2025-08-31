//
//  CategoryListViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/13/25.
//

import Foundation
import UIKit
import SwiftUI

final class CategoryCell: UITableViewCell {
    static let reuseId = "CategoryCell"
    func configure() {
        self.contentConfiguration = UIHostingConfiguration {
            CategoryCellView()
        }
        self.selectionStyle = .none
    }
}

struct CategoryCellView: View {
    var name: String = "카테고리 1"
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: ComponentSize.leadingImgSize, height: ComponentSize.leadingImgSize)
                .foregroundStyle(Color.systemPointRed)
            
            Text(name)
                .moneyTogetherFont(style: .b2)
                .foregroundStyle(Color.moneyTogether.label.normal)
        }
    }
}

final class CategoryListViewController: UIViewController {
    
    // MARK: Properties
    
    var viewModel: WalletViewModel
//    var tappedCateogry: Binder<Category>
    
    var data: [Category] = Category.createDummyList()
    
    // MARK: Sub Views
    
    private var navigationBar: CustomNavigationBar!
    
    lazy private var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    
    // MARK: Init & Setup
    
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
        self.view.backgroundColor = .moneyTogether.background
        
        self.navigationBar = CustomNavigationBar(
            title: "카테고리",
            backBtnMode: .push,
            backAction: {
                print(#fileID, #function, #line, "back btn tapped")
                self.viewModel.onBackTapped?(.categoryList)
            })
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseId)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 56, right: 0)
        tableView.rowHeight = 56
        tableView.separatorColor = .clear
//            .moneyTogether.line.normal
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseId, for: indexPath) as? CategoryCell
        cell?.configure()
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "\((data[indexPath.row]).name) is selected")
    }
}

//#Preview {
//    CategoryListViewController()
//}
