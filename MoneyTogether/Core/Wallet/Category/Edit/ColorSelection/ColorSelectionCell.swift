//
//  ColorSelectionCell.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/3/25.
//

import Foundation
import UIKit

/// 컬러 선택 컬렉션 뷰 cell
class ColorSelectionCell: UICollectionViewCell {
    
    static let reuseId = "ColorSelectionCell"
    
    static let size = ProfileImgSize.medium
    
    
    // MARK: UI Components
    
    private var palette: UIView!
    
    
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
        self.palette = {
            let view = UIView().disableAutoresizingMask()
            view.backgroundColor = .moneyTogether.brand.primary
            view.layer.cornerRadius = ColorSelectionCell.size / 2
            
            view.widthAnchor.constraint(equalToConstant: ColorSelectionCell.size).isActive = true
            view.heightAnchor.constraint(equalToConstant: ColorSelectionCell.size).isActive = true
            
            return view
        }()
        
        self.addSubview(palette)
        
        NSLayoutConstraint.activate([
            palette.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            palette.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func configure(with color: PaletteColor) {
        self.palette.backgroundColor = color.uiColor
//            .withAlphaComponent(0.6)
    }
}
