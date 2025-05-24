//
//  UIImageView+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/19/25.
//

import Foundation
import UIKit

extension UIImageView {
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
}
