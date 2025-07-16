//
//  UIImageView+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/19/25.
//

import Foundation
import UIKit

extension UIImageView {
    /// 원형 이미지 뷰를 생성
    /// - Parameters:
    ///   - image: 표시할 UIImage 객체
    ///   - size: 이미지 뷰의 너비와 높이 (정사각형 기준)
    ///   - contentMode: 이미지의 콘텐츠 모드 (default: .scaleAspectFill)
    ///   - backgroundColor: 이미지 뷰의 배경색 (default: .clear)
    ///   - tinColor: 이미지의 템플릿 렌더링 시 사용할 색상 (default: .moneyTogether.label.normal)
    /// - Returns: 설정이 적용된 UIImageView 인스턴스
    static func makeCircleImg(image: UIImage?,
                       size: CGFloat,
                       contentMode: UIView.ContentMode = .scaleAspectFill,
                       backgroundColor: UIColor? = .clear,
                       tinColor: UIColor? = .moneyTogether.label.normal
    ) -> UIImageView {
        let imgView = UIImageView(image: image).disableAutoresizingMask()
        imgView.image = image?.withRenderingMode(.alwaysTemplate)
        imgView.contentMode = contentMode
        imgView.backgroundColor = backgroundColor
        imgView.tintColor = tinColor
        
        imgView.widthAnchor.constraint(equalToConstant: size).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: size).isActive = true
        imgView.layer.cornerRadius = size / 2
        
        return imgView
    }
    
    /// 아이콘 이미지 스타일로 UIImageView를 설정
    /// - Parameters:
    ///   - iconColor: 아이콘 이미지 색상 (default: .moneyTogether.label.alternative)
    ///   - size: 아이콘 이미지 뷰의 너비와 높이 (정사각형 기준) (default: ComponentSize.iconBtnImageSize = 24)
    func iconStyle(iconColor: UIColor? = .moneyTogether.label.alternative,
                   size: CGFloat = ComponentSize.iconBtnImageSize) {
        
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.contentMode = .scaleAspectFit
        self.tintColor = iconColor
        self.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: size),
            self.heightAnchor.constraint(equalToConstant: size)
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
