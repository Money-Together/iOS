//
//  WalletMembersPreview.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/1/25.
//

import Foundation
import SwiftUI

/// 공유 멤버 프리뷰
/// 3명까지만 프로필 이미지 + 그 외 인원 수 텍스트로 보여짐
/// 프리뷰 탭 시 전체 멤버 리스트 볼 수 있음
struct WalletMembersPreview: View {
    
    var members: [WalletMember]
    
    init(members: [WalletMember]) {
        self.members = members
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(members.prefix(3).enumerated()), id: \.offset) { index, member in
                createMemberProfileImgView(imgUrl: member.profileImg)
                    .offset(x: CGFloat((-2 * index)))
            }
            
            if members.count > 3 {
                Text("외 \(members.count - 3)명")
                    .moneyTogetherFont(style: .b1)
                    .foregroundStyle(Color.moneyTogether.label.alternative)
                    .padding(.horizontal, 4)
            }
        }
        .frame(height: 40)
    }
    
    /// 멤버 프리뷰에 사용되는 멤버 프로필 이미지 뷰 생성 함수
    private func createMemberProfileImgView(imgUrl: String?) -> some View {
        ProfileImageView(size: ProfileImgSize.small, imageUrl: imgUrl)
            .background(
                Circle()
                    .fill(Color.moneyTogether.grayScale.baseGray0)
                    .frame(width: ProfileImgSize.small + 4, height: ProfileImgSize.small + 4)
            )
    }
}

struct InviteMemberView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("지갑을 공유할 멤버를 초대해보세요.\n거래 내역을 함께 기록할 수 있습니다.")
                .moneyTogetherFont(style: .b2)
                .foregroundStyle(Color.moneyTogether.label.normal)
                .lineSpacing(4)
            
            HStack(spacing: 16) {
                CTAButton(activeState: .active, buttonStyle: .solid, labelText: "카카오톡 초대", labelFontStyle: .b1, buttonHeight: 48, buttonWidth: 120, cornerRadius: Radius.medium, action: {
                    
                })
                
                CTAButton(activeState: .active, buttonStyle: .solid, labelText: "초대링크 복사", labelFontStyle: .b1, buttonHeight: 48, buttonWidth: 120, cornerRadius: Radius.medium, action: {
                    
                })
            }
        }.padding()
    }
}


