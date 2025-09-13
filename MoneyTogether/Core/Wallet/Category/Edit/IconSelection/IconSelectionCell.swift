//
//  IconSelectionCell.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/3/25.
//

import Foundation
import UIKit

/// 아이콘 선택 컬렉션 뷰 cell
class IconSelectionCell: UICollectionViewCell {
    
    static let reuseId = "IconSelectionCell"
    
    static let size = ProfileImgSize.medium
    
    
    // MARK: UI Components
    
    var palette: UIView!
    
    private var iconImageView: UIImageView!
    
    
    // MARK: Init & Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// sub views, ui components 세팅하는 함수
    private func setup() {
        self.backgroundColor = .clear
        
        self.iconImageView =  {
            let imageView = UIImageView(image: nil).disableAutoresizingMask()
            
            let tmpImg = UIImage(systemName: "questionmark.app")
            imageView.image = tmpImg?.withRenderingMode(.alwaysTemplate)
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .clear
            imageView.tintColor = UIColor.moneyTogether.label.alternative
            
            imageView.widthAnchor.constraint(equalToConstant: IconSelectionCell.size - 8).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: IconSelectionCell.size - 8).isActive = true
            
            return imageView
        }()
        
        self.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func configure(with image: UIImage?) {
        self.iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
    }
}

