//
//  UISheetPresentationController+DetentHelpers.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/1/25.
//

import Foundation
import UIKit

extension UISheetPresentationController.Detent {
    /// 지정한 비율만큼의 높이를 가지는 커스텀 sheet detent
    static func customFraction(_ value: CGFloat) -> UISheetPresentationController.Detent {
        return .custom(identifier: .init("fraction_\(value)")) { context in
            return context.maximumDetentValue * value
        }
    }
    
    /// 고정 높이를 가지는 커스텀 sheet detent
    static func fixedHeight(_ value: CGFloat) -> UISheetPresentationController.Detent {
        return .custom(identifier: .init("height_\(Int(value))")) { _ in
            return value
        }
    }
    
    /// 전체 화면 높이에 따라 비율을 다르게 가지는 커스텀 sheet detent
    static func adaptive(
        identifier: String = "adaptive",
        smallHeightThreshold: CGFloat = 500,
        smallHeightFraction: CGFloat = 0.5,
        defaultFraction: CGFloat = 0.3) -> UISheetPresentationController.Detent {
        
        return .custom(identifier: .init(identifier)) { context in
            let maxHeight = context.maximumDetentValue
            
            if maxHeight < smallHeightThreshold {
                return maxHeight * smallHeightFraction
            } else {
                return maxHeight * defaultFraction
            }
        }
    }
}
