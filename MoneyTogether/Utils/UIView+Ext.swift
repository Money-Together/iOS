//
//  UIView+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/28/25.
//

import Foundation
import UIKit

extension UIView {
    /// view의 translatesAutoresizingMaskIntoConstraints 값을 false로 처리
    func disableAutoresizingMask() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

