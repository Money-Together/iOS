//
//  ComponentSize.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/29/25.
//

import Foundation

struct ComponentSize {
    static let navigationBarHeight: CGFloat = 56
    
    static let iconBtnSize: CGFloat         = 40
    static let ctaBtnHeight: CGFloat        = 48
    
    static let profileImgSize = ProfileImgSize()
}

/// 프로필 이미지 사이즈
struct ProfileImgSize {
    static let small: CGFloat   = 32
    static let medium: CGFloat  = 40
    static let large: CGFloat   = 64
    static let xLarge: CGFloat  = 96
}
