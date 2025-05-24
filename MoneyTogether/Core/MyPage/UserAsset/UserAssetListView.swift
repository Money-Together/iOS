//
//  UserAssetListView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/15/25.
//

import Foundation
import UIKit
import SwiftUI

protocol UserAssetListViewDelegate: AnyObject {
    func assetListView(_ listView: UserAssetListView, didTapAsset id: UUID)
}


/// 유저 자산 리스트
class UserAssetListView: UIView {
    
    var assetViews: [UUID: UIView] = [:]
    
    weak var delegate: UserAssetListViewDelegate?
    
//    var onAssetCellTapped: ((UUID) -> Void)?

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
    
    /// 변경된 데이터로 ui 업데이트
    /// - Parameter newData: 변경된 데이터
    func updateUI(newData: [UserAsset]) {
        
        // 기존 ui 삭제
        stackView.clear()
        assetViews = [:]
        
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
            self.addAseetRow(asset: asset)
        }
    }
}


// MARK: Asset Row CRUD
extension UserAssetListView {
    
    private func makeAssetRow(asset: UserAsset) -> UIView {
        let cell = UserAssetCellView(userAsset: asset, tapHandler: { assetId in
            self.delegate?.assetListView(self, didTapAsset: assetId)
        })
        
        let hostingVC = UIHostingController(rootView: cell)
        let cellView = hostingVC.view.disableAutoresizingMask()
        cellView.backgroundColor = .clear
        
        return cellView
    }
    
    func addAseetRow(asset: UserAsset) {
        let cellView = makeAssetRow(asset: asset)
        self.assetViews[asset.id] = cellView
        self.stackView.addArrangedSubview(cellView)
    }
    
    func removeAssetView(assetId: UUID) {
        guard let view = self.assetViews[assetId] else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.stackView.layoutIfNeeded()
        }, completion: { _ in
            self.stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        })
    }
}

