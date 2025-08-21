//
//  AssetSelectionCell.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/21/25.
//

import Foundation
import UIKit

/// 자산 선택 모달에서 사용되는 컬렉션뷰 cell
class AssetSelectionCell: UICollectionViewCell {
    static let reuseId = "AssetSelectionCell"
    static let cellHeight: CGFloat = 40
    static let horizontalPadding: CGFloat = 20
    
    private var nameLabel: UILabel!
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    /// sub views, ui components 세팅하는 함수
    private func setUI() {
        self.backgroundColor = UIColor.moneyTogether.grayScale.baseGray20
        self.layer.cornerRadius = AssetSelectionCell.cellHeight / 2

        nameLabel = UILabel.make(
            text: "자산1",
            font: .moneyTogetherFont(style: .b2),
            numberOfLines: 1
        )
        
        self.addSubview(nameLabel)
    }
    
    /// sub views를 추가하고, 레이아웃을 설정하는 함수
    private func setLayout() {
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func configure(name: String) {
        self.nameLabel.text = name
    }
}
