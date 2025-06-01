//
//  ComponentSize.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/29/25.
//

import Foundation

/// 컴포넌트 사이즈
struct ComponentSize {
    /// 네비게이션 바 높이
    static let navigationBarHeight: CGFloat = 56
    
    /// 아이콘 버튼 사이즈 (width, height 동일)
    static let iconBtnSize: CGFloat         = 48
    
    /// 아이콘 버튼 이미지 사이즈 (width, height 동일)
    /// 이미지 사이즈 = 전체 아이콘 버튼 크기 / 2 (패딩 기본 값 = 이미지 사이즈 / 2)
    static let iconBtnImageSize: CGFloat    = 24
    
    /// CTA 버튼 높이
    static let ctaBtnHeight: CGFloat        = 48
    
    /// 프로필 이미지 사이즈 (width, height 동일)
    static let profileImgSize = ProfileImgSize()
    
    /// list cell 뷰에 앞부분에 있는 이미지 사이즈 (width, height 동일)
    static let leadingImgSize: CGFloat      = 32
}

/// 프로필 이미지 사이즈
struct ProfileImgSize {
    static let small: CGFloat   = 32
    static let medium: CGFloat  = 40
    static let large: CGFloat   = 64
    static let xLarge: CGFloat  = 96
}
