//
//  UIViewController+Alert.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/24/25.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(title: String = "오류가 발생했습니다.", message: String = "잠시 후 다시 시도해주세요.") {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(title: "확인", style: .default, handler: nil)
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}
