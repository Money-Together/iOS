//
//  UserAssetListView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/15/25.
//

import Foundation
import UIKit
import SwiftUI

/// 유저 자산 리스트
class UserAssetListView: UIView {

    // MARK: UI Components
    
    var stackView = UIStackView.makeVStack(
        distribution: .fillEqually,
        alignment: .fill,
        spacing: 20,
        subViews: [])
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setLayout()
        self.setAction()
    }
    
    /// sub views, ui components 세팅하는 함수
    private func setUI() {
        
        if stackView.arrangedSubviews.isEmpty {
            stackView.addArrangedSubview(
                UILabel.make(
                    text: "자산이 없습니다. 추가해주세요",
                    numberOfLines: 1
                )
            )
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// sub views를 추가하고, 레이아웃을 설정하는 함수
    private func setLayout() {
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    /// sub views, ui components에서 필요한 액션 세팅하는 함수
    private func setAction() {
        
    }
}


// MARK: update UI
extension UserAssetListView {
    
    /// 변경된 데이터로 ui 업데이트
    /// - Parameter newData: 변경된 데이터
    func updateUI(newData: [UserAsset]) {
        
        // 기존 ui 삭제
        stackView.clear()
        
        // 유저 자산이 없을 경우
        guard !newData.isEmpty else {
            stackView.addArrangedSubview(
                UILabel.make(
                    text: "자산이 없습니다. 추가해주세요",
                    numberOfLines: 1
                )
            )
            
            return
        }
        
        // ui 업데이트
        newData.forEach { asset in
            let cell = UserAssetCellView(userAsset: asset)
            
            let hostingVC = UIHostingController(rootView: cell)
            let cellView = hostingVC.view.disableAutoresizingMask()
            cellView.backgroundColor = .clear
            
            self.stackView.addArrangedSubview(cellView)
        }
    }
}
