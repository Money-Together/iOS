//
//  CustomIconButton.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/29/25.
//

import Foundation
import UIKit

/// 아이콘 버튼
class CustomIconButton: UIView {
    
    /// 버튼 클릭 액션
    private var btnAction: (() -> Void)?
    
    /// 버튼 사이즈
    private var btnSize: CGFloat
    
    
    // MARK: UI Components
    
    private let button: UIButton = {
        let btn = UIButton().disableAutoresizingMask()
        btn.backgroundColor = .clear
        
        return btn
    }()
    
    private var iconImageView: UIImageView = {
        let tmpImg = UIImage(systemName: "questionmark.app")
        let imgView = UIImageView(image: tmpImg).disableAutoresizingMask()
        
        return imgView
    }()
    
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 커스텀 아이콘 버튼 init
    /// - Parameters:
    ///   - iconImage: 아이콘이미지
    ///   - iconColor: 아이콘 컬러, default = .moneyTogether.label.normal
    ///   - backgroundColor: 백그라운드컬러, default = .clear
    ///   - size: 아이콘 버튼 사이즈(width = height), default = 40
    ///   - cornerRadius: 아이콘 버튼 뷰 corner radius, default = Radius.small
    ///   - action: 버튼 클릭 이벤트 액션
    init(iconImage: UIImage?,
         iconColor: UIColor? = .moneyTogether.label.normal,
         backgroundColor: UIColor? = .clear,
         size: CGFloat = 40,
         cornerRadius: CGFloat = Radius.small,
         action: (() -> Void)? = nil) {
        
        self.btnSize = size
        self.btnAction = action
        
        super.init(frame: .zero)
        
        self.setUI(iconImage: iconImage,
                   iconColor: iconColor,
                   backgroundColor: backgroundColor,
                   cornerRadius: cornerRadius)
        
        self.setLayout()
        
        self.button.addAction(UIAction(handler: { _ in
            self.handleButtonTap()
        }), for: .touchUpInside)
    }
    
    private func setUI(iconImage: UIImage?,
                       iconColor: UIColor? = .moneyTogether.label.normal ,
                       backgroundColor: UIColor? = .clear,
                       cornerRadius: CGFloat = Radius.small) {
        self.iconImageView.image = iconImage?.withRenderingMode(.alwaysTemplate)
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.backgroundColor = backgroundColor
        self.iconImageView.tintColor = iconColor
        self.button.tintColor = backgroundColor
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
    }
    
    private func setLayout() {
        self.addSubview(iconImageView)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: btnSize),
            self.heightAnchor.constraint(equalToConstant: btnSize),
            
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setAction(_ action: (() -> Void)?) {
        self.btnAction = action
    }
}


// MARK: Action

extension CustomIconButton {
    
    /// 버큰 클릭 이벤트 처리
    private func handleButtonTap() {
        self.btnAction?() ?? { fatalError("Custom Icon Button action should be implemented") }()
    }
}
