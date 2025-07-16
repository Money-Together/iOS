//
//  UIView+Shadow.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/11/25.
//

import Foundation
import UIKit

extension UIView {
    /// UIVIew에 그림자를 추가하는 함수
    /// - Parameters:
    ///   - color: 그림자 색상
    ///   - offset: 그림자 위치
    ///   - opacity: 그림자 투명도 ( 0 ~ 1 )
    ///   - radius: 그림자의 블러 정도 지정 (숫자가 클수록 퍼지는 효과)
    func addShadow(color: UIColor?,
                   offset: CGSize,
                   opacity: Float,
                   radius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = (color ?? .gray30).cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
