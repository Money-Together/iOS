//
//  WalletMemberCellView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/1/25.
//

import Foundation
import SwiftUI

/// 지갑 멤버 리스트 custom cell
/// SwiftUI 뷰를 호스팅해 UITableView에서 사용할 Cell 구성
class WalletMemberCell: UITableViewCell {
    static let reuseId: String = "WalletMemberCell"
    
    func configure(with data: WalletMember) {
        self.contentConfiguration = UIHostingConfiguration {
            WalletMemberCellView(member: data)
        }
        self.selectionStyle = .none
    }
}

// SwiftUI View로 구성된 지갑 멤버 Cell
struct WalletMemberCellView: View {
    
    // 멤버 프로필 이미지 URL
    var profileImgUrl: String?
    
    // 멤버 닉네임
    var nickname: String?
    
    // WalletMember 데이터를 받아 뷰 속성 초기화
    init(member: WalletMember) {
        self.profileImgUrl = member.profileImg
        self.nickname = member.nickname
    }
    
    var body: some View {
        HStack {
            ProfileImageView(size: ProfileImgSize.small, imageUrl: profileImgUrl)
            Text(nickname ?? "no name")
            Spacer()
        }
    }
}
