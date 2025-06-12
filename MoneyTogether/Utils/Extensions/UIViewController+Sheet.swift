//
//  UIViewController+Sheet.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/12/25.
//

import Foundation
import UIKit

extension UIViewController {
    /// 바텀 시트를 띄우는 함수
    /// - Parameters:
    ///   - viewController: 바텀시트 내부 뷰 컨트롤러
    ///   - detents: 시트 높이
    func showSheet(viewController: UIViewController, detents: [UISheetPresentationController.Detent]) {
        viewController.modalPresentationStyle = .formSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = detents
            sheet.largestUndimmedDetentIdentifier = .none
        }
        self.present(viewController, animated: true)
    }
}
