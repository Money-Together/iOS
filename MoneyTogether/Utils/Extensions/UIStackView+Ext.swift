//
//  UIStackView+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/2/25.
//

import Foundation
import UIKit

extension UIStackView {
    /// 스택뷰 생성 함수
    private class func make(
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution,
        alignment: UIStackView.Alignment,
        spacing: CGFloat,
        subViews: [UIView] = []) -> UIStackView
    {
        let stk = UIStackView().disableAutoresizingMask()
        
        stk.axis = axis
        stk.distribution = distribution
        stk.alignment = alignment
        stk.spacing = spacing
        
        // sub view가 있을 경우 추가
        guard subViews.count != 0 else {
            return stk
        }
        subViews.forEach {
            stk.addArrangedSubview($0)
        }
        
        return stk
    }
    
    /// vertical stack 생성
    class func makeVStack(
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0,
        subViews: [UIView] = []) -> UIStackView
    {
        return UIStackView.make(axis: .vertical,
                                distribution: distribution,
                                alignment: alignment,
                                spacing: spacing,
                                subViews: subViews)
    }
    
    /// horizontal stack 생성
    class func makeHStack(
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0,
        subViews: [UIView] = []) -> UIStackView
    {
        return UIStackView.make(axis: .horizontal,
                                distribution: distribution,
                                alignment: alignment,
                                spacing: spacing,
                                subViews: subViews)
    }
    
    /// 스택 하위 뷰 제거
    func clear() {
        self.arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
