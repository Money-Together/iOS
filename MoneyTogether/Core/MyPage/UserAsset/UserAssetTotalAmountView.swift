//
//  UserAssetTotalAmountView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/13/25.
//

import Foundation
import UIKit
import SwiftUI

class UserAssetTotalAmountView: UIView {
    
    // MARK: UI Components
    var stackView = UIStackView.makeVStack(
        distribution: .fillEqually,
        alignment: .fill,
        spacing: 12,
        subViews: []
    )
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setUI()
        self.setLayout()
    }
    
    /// sub views, ui components 세팅하는 함수
    private func setUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// sub views를 추가하고, 레이아웃을 설정하는 함수
    private func setLayout() {
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

// MARK: update UI
extension UserAssetTotalAmountView {
    
    /// 변경된 데이터로 ui 업데이트
    /// - Parameter newData: 변경된 데이터
    func updateUI(newData: [CurrencyType : String]) {
        newData.forEach { amount in
            let cell = UserAssetTotalAmountCellView(currencyType: amount.key, amount: amount.value)
            
            let hostingVC = UIHostingController(rootView: cell)
            let cellView = hostingVC.view.disableAutoresizingMask()
            cellView.backgroundColor = .clear
//            cellView.backgroundColor = .moneyTogether.grayScale.baseGray20
            
            self.stackView.addArrangedSubview(cellView)
        }
    }
}
    
