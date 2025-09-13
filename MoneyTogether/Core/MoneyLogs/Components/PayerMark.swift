//
//  PayerMark.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/25/25.
//

import Foundation
import SwiftUI

/// 결제자 프로필 이미지에 붙는 마크 이미지
//var PayerMark: some View {
//    Image("crown")
//        .iconStyle(size: 20, foregroundColor: .yellow, padding: 0)
//        .offset(y: -(ComponentSize.leadingImgSize / 2) - 2)
//}

struct PayerMark: View {
    let profileImgSize: CGFloat
    let iconSize: CGFloat
    
    init(profileImgSize: CGFloat = ComponentSize.leadingImgSize,
         iconSize: CGFloat = 20) {
        self.profileImgSize = profileImgSize
        self.iconSize = iconSize
    }
    
    var body: some View {
        Image("crown")
            .iconStyle(size: iconSize, foregroundColor: .yellow, padding: 0)
            .offset(y: -(profileImgSize / 2) - 2)
    }
}
