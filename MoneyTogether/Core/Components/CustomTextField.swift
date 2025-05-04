//
//  CustomTextField.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/28/25.
//

import Foundation
import UIKit

#warning("custom text field 스타일 임시")

/// 커스텀 텍스트 필드
class CustomTextField: UITextField {

    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String = "입력해주세요.") {
        super.init(frame: .zero)
        
        self.setUI(placeholder: placeholder)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUI(placeholder: String) {
        self.backgroundColor = .white
        
        self.placeholder = placeholder
        self.textColor = UIColor.moneyTogether.label.normal
        self.font = UIFont.moneyTogetherFont(style: .b1)
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        self.layer.borderColor = UIColor.moneyTogether.label.normal?.cgColor
        self.borderStyle = .roundedRect
        
        self.clearButtonMode = .whileEditing
        self.autocapitalizationType = .none
        
    }
}

//        let textFieldView: UIView = {
//            let view = UIView().disableAutoresizingMask()
//
//            view.addSubview(nicknameTextField)
////            view.backgroundColor = .yellow
//            view.layer.cornerRadius = Radius.small
//            view.layer.borderColor = UIColor.moneyTogether.line.normal?.cgColor
//            view.layer.borderWidth = 1
//
//            NSLayoutConstraint.activate([
//                view.heightAnchor.constraint(equalToConstant: 48),
//
//                nicknameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                nicknameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//                nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
//                nicknameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
//            ])
//
//            return view
//
//        }()
