//
//  FontWeight.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/24/25.
//

import UIKit

/// 커스텀 폰트 두께
enum FontWeight {
    case bold, regular
    
    /// weight 타입에 맞는 폰트 이름
    var fontName: String {
        switch self {
        case .bold: return "Pretendard-Bold"
        case .regular: return "Pretendard-Regular"
        }
    }
    
    /// UIFont 시스템 weight
    var systemUIWeight: UIFont.Weight {
        switch self {
        case .bold : .bold
        case .regular: .regular
        }
    }
}
