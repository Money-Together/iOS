//
//  WalletProfileView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/26/25.
//

import Foundation
import SwiftUI


/// 지갑 홈에 들어갈 지갑 프로필 뷰
struct WalletProfileView: View {
    /// 지갑 이름
    var walletName: String
    
    /// 지갑 설명
    var walletBio: String
    
    /// 지갑 공유 멤버 리스트
    var members: [String] = Array(repeating: "a", count: 100)
    
    /// 저금통 사용 여부
    var hasCashBox: Bool
    
    /// 저금통 금액
    var cashBoxAmount: String
    
    
    init(wallet: Wallet) {
        self.walletName = wallet.name
        self.walletBio = wallet.bio ?? ""
        self.hasCashBox = wallet.hasCashBox
//        self.cashBoxAmount = "10,000 원"
        if let cashbox = wallet.cashBox,
           hasCashBox == true {
            self.cashBoxAmount = cashbox.amount + " " + cashbox.currency.readableName
            self.cashBoxAmount = cashbox.currency.symbol + " " + cashbox.amount
        } else {
            self.cashBoxAmount = ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(walletName)
                .moneyTogetherFont(style: .h4)
                .foregroundStyle(Color.moneyTogether.label.normal)
                .lineLimit(1)
            
            // 지갑 설명이 있을 경우에만 보이기
            if (walletBio.count > 0) {
                Text(walletBio)
                    .moneyTogetherFont(style: .b2)
                    .lineSpacing(4)
                    .foregroundStyle(Color.moneyTogether.label.alternative)
            }
            
            HStack {
                memberPreview
                Spacer()
                
                // 저금통 금액 줄여보이기 방지용
                // 금액이 작을 경우 멤버 프리뷰와 같은 라인에 보임
                if hasCashBox && cashBoxAmount.count <= 10 {
                    cashBoxView
                }
            }.padding(.top, 8)
            
            // 저금통 금액 줄여보이기 방지용
            // 금액이 클 경우 멤버 프리뷰 아래에 보임
            if hasCashBox && cashBoxAmount.count > 10 {
                cashBoxView
            }
        }
        .background(.clear)
    }
    
    /// 공유 멤버 프리뷰
    /// 3명까지만 프로필 이미지 + 그 외 인원 수 텍스트로 보여짐
    /// 프리뷰 탭 시 전체 멤버 리스트 볼 수 있음
    var memberPreview: some View {
        HStack(spacing: 0) {
            ForEach(Array(members.prefix(3).enumerated()), id: \.offset) { index, member in
                createMemberProfileImgView()
                    .offset(x: CGFloat((-2 * index)))
            }
            
            if members.count > 3 {
                Text("외 \(members.count - 3)명")
                    .moneyTogetherFont(style: .b1)
                    .foregroundStyle(Color.moneyTogether.label.alternative)
                    .padding(.horizontal, 4)
            }
            Spacer()
        }
        .frame(height: 40)
        .onTapGesture {
            print(#fileID, #function, #line, "✅ show more wallet members")
        }
    }
    
    /// 저금통 아이콘
    private var cashboxIconImg: some View {
        Circle()
            .fill(Color.moneyTogether.grayScale.baseGray0)
            .frame(width: ComponentSize.leadingImgSize, height: ComponentSize.leadingImgSize)
            .overlay(
                Image("savings")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.moneyTogether.label.alternative)
                    .clipped()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            )
            
    }
    
    /// 저금통 아이콘 + 금액
    var cashBoxView: some View {
        HStack(spacing: 12) {
            cashboxIconImg
            
            Text(cashBoxAmount)
                .moneyTogetherFont(style: .b1)
                .foregroundStyle(Color.moneyTogether.label.alternative)
        }
    }
    
    /// 멤버 프리뷰에 사용되는 멤버 프로필 이미지 뷰 생성 함수
    private func createMemberProfileImgView() -> some View {
        ProfileImageView(size: ProfileImgSize.small)
            .background(
                Circle()
                    .fill(Color.moneyTogether.grayScale.baseGray0)
                    .frame(width: ProfileImgSize.small + 4, height: ProfileImgSize.small + 4)
            )
    }
}

#Preview {
    WalletHomeViewController()
//    return WalletProfileView(wallet: Wallet.createDummyData())
}
