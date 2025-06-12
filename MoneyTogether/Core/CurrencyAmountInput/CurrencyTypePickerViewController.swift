//
//  CurrencyTypePickerViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/19/25.
//

import Foundation
import UIKit


final class CurrencyTypeCellView: UITableViewCell {
    // MARK: Properties
    static let reuseId: String = "currencyTypeCellView"
    
    private var currencyType: CurrencyType = .krw
    
    // MARK: UI Components

    private var flagImage: UIImageView!
    
    private var title: UILabel!
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUI()
        self.setLayout()
    }
    
    /// sub views, ui components 세팅하는 함수
    private func setUI() {
        self.backgroundColor = UIColor.moneyTogether.background
        self.selectionStyle = .none
        
        flagImage = createFlagImage()
        
        title = UILabel.make(
            text: "\(currencyType.country) \(currencyType.displayName)",
            font: .moneyTogetherFont(style: .b2),
            numberOfLines: 1
        )
        
    }
    
    /// sub views를 추가하고, 레이아웃을 설정하는 함수
    private func setLayout() {
        
        self.addSubview(flagImage)
        self.addSubview(title)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 56),
            
            flagImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Layout.side),
            flagImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            title.leadingAnchor.constraint(equalTo: flagImage.trailingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Layout.side),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func updateUI(type: CurrencyType) {
        self.currencyType = type
        self.flagImage = createFlagImage()
        self.title.text = "\(currencyType.country) \(currencyType.displayName)"
    }
    
    private func createFlagImage() -> UIImageView {
        let img = UIImage(named: currencyType.flagImageName)
        return UIImageView.makeCircleImg(
            image: img,
            size: ComponentSize.leadingImgSize,
            backgroundColor: .moneyTogether.system.green
        )
    }
}

class CurrencyTypePickerViewController: UIViewController {
    
    // MARK: Properties
    // var viewModel: EditUserAssetViewModel
    
    var selectedCurrency: Binder<CurrencyType>
    
    var data: [CurrencyType] = CurrencyType.allCases
    
    // MARK: Sub Views
    
//    private var sectionHeader = UILabel.make(
//        text: "통화 선택",
//        textColor: .moneyTogether.label.assistive,
//        font: .moneyTogetherFont(style: .detail1),
//        numberOfLines: 1
//    )
    
    //private var sectionHeader: CustomNavigationBar!
    
    private var sectionHeader: ModalHeaderView!
    
    lazy private var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    
    // MARK: Init & Setup
    
    init(defaultCurrency: CurrencyType = .krw) {
        self.selectedCurrency = Binder(.krw)
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
        
//        self.sectionHeader = CustomNavigationBar(
//            title: "통화 선택",
//            backBtnMode: .modal, backAction: {
//                self.dismiss(animated: true)
//            })
        
        self.sectionHeader = ModalHeaderView(title: "통화 선택" , onCancel: {
            self.dismiss(animated: true)
        })
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CurrencyTypeCellView.self, forCellReuseIdentifier: CurrencyTypeCellView.reuseId)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 56, right: 0)
        tableView.rowHeight = 56
        tableView.separatorColor = .clear
//            .moneyTogether.line.normal
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        
        
    }
    
    private func setLayout() {
        self.view.addSubview(sectionHeader)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            sectionHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sectionHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sectionHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //constant: 24),
            
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: sectionHeader.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CurrencyTypePickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTypeCellView.reuseId, for: indexPath) as? CurrencyTypeCellView
        cell?.updateUI(type: data[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "\((data[indexPath.row]).displayName) is selected")
        self.selectedCurrency.value = data[indexPath.row]
        self.dismiss(animated: true)
    }
}


#if DEBUG

import SwiftUI

#Preview {
    CurrencyTypePickerViewController()
}

#endif

