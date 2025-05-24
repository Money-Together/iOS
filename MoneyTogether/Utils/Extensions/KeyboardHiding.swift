//
//  KeyboardHiding.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/28/25.
//

import Foundation
import UIKit

extension UIViewController {
    /// 화면 탭 시 키보드 숨김 처리 설정
    /// view controller에서 호출 시, 해당 VC에서 화면 탭으로 키보드 숨김 가능
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    /// 키보드 숨기기 기능 처리
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

