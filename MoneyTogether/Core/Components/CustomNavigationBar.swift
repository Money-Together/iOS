//
//  CustomNavigationBar.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/29/25.
//

import Foundation
import UIKit

/// 화면 전환 타입에 따른 뒤로가기 버튼 모드
enum BackButtonMode {
    case push
    case modal
    case none
}

/// 카스텀 네비게이션 바
class CustomNavigationBar: UIView {
    
    // MARK: Properties
    
    let height: CGFloat = ComponentSize.navigationBarHeight
    
    let backButtonMode: BackButtonMode
    
    var backAction: (() -> Void)?
    
    // MARK: UI Components
    
    var titleLabel: UILabel = {
        let label = UILabel().disableAutoresizingMask()
        label.text = ""
        label.font = .moneyTogetherFont(style: .h6)
        label.textColor = .moneyTogether.label.normal
        
        return label
    }()
    
    /// 타이틀 왼쪽에 들어갈 버튼 스택
    let leftBtnStk = UIStackView.makeHStack(
        distribution: .fill,
        alignment: .center,
        spacing: 4
    )
    
    /// 타이틀 오른쪽에 들어갈 버튼 스택
    let rightBtnStk = UIStackView.makeHStack(
        distribution: .fill,
        alignment: .center,
        spacing: 4
    )
    
    /// 네비게이션 push 스타일 백 버튼
    var pushStyleBackBtn: CustomIconButton!
    
    /// 모달 present 스타일 백 버튼
    var modalStyleBackBtn: CustomIconButton!
    
    
    // MARK: Init & Setup
    
    init(title: String = "",
         backgroundColor: UIColor? = .clear,
         backBtnMode: BackButtonMode = .none,
         backAction: (() -> Void)? = nil) {
        
        self.titleLabel.text = title
        self.backButtonMode = backBtnMode
        self.backAction = backAction
        
        super.init(frame: .zero)
        
        setUI(backgroundColor: backgroundColor)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        
        // 네비게이션 push 스타일 백 버튼 초기화
        self.pushStyleBackBtn = CustomIconButton(
            iconImage: UIImage(systemName: "chevron.left"),
            action: {
                self.doBackAction()
            }
        )
        
        // 모달 present 스타일 백 버튼 초기화
        self.modalStyleBackBtn = CustomIconButton(
            iconImage: UIImage(systemName: "x.square"),
            action: {
                self.doBackAction()
            }
        )
    }
    
    func setLayout() {
        // 백 버튼 모드에 따라 버튼 스택에 버튼 추가
        switch self.backButtonMode {
        case .push:
            self.leftBtnStk.addArrangedSubview(self.pushStyleBackBtn)
        case .modal:
            self.rightBtnStk.addArrangedSubview(self.modalStyleBackBtn)
        default: break
        }
        
        self.addSubview(leftBtnStk)
        self.addSubview(titleLabel)
        self.addSubview(rightBtnStk)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height),
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            self.leftBtnStk.heightAnchor.constraint(equalToConstant: ComponentSize.iconBtnSize),
            self.rightBtnStk.heightAnchor.constraint(equalToConstant: ComponentSize.iconBtnSize),
            
            self.leftBtnStk.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            self.leftBtnStk.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.rightBtnStk.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: -12),
            self.rightBtnStk.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

// MARK: Action

extension CustomNavigationBar {
    func doBackAction() {
        self.backAction?()
    }
}
