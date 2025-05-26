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
        
        self.clearButtonMode = .whileEditing    // 입력내용 전체 삭제 버튼 활성화 여부
        self.clearsOnBeginEditing = false       // 편집 시작 시 기존 내용 삭제 기능 활성화 여부
        
        self.autocapitalizationType = .none     // 자동 대문자 활성화 여부
        self.autocorrectionType = .no           // 자동 수정 활성화 여부
        self.spellCheckingType = .no            // 맞춤법 검사 활성화 여부
        
        self.returnKeyType = .done              // 엔터 키 입력 시 처리
        
        self.keyboardType = UIKeyboardType.default  // 키보드 타입
        
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
