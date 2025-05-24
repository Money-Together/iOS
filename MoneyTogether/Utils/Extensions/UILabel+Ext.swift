//
//  UILabel+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/28/25.
//

import Foundation
import UIKit

extension UILabel {
    
    /// 커스텀 UILabel 생성
    class func make(
        text: String,
        textColor: UIColor? = UIColor.moneyTogether.label.normal,
        font: UIFont = .moneyTogetherFont(style: .b1),
        numberOfLines: Int = 0
    ) -> UILabel {
        let label = UILabel().disableAutoresizingMask()
        
        label.text = text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = numberOfLines
        
        return label
    }
}

