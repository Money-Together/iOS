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
    
    @ObservedObject var viewModel: WalletViewModel
    
    /// 지갑 이름
    var walletName: String {
        viewModel.walletData?.name ?? ""
    }
    
    /// 지갑 설명
    var walletBio: String {
        viewModel.walletData?.bio ?? ""
    }
    
    /// 지갑 공유 멤버 리스트
    var members: [WalletMember] {
        viewModel.members
    }
    
    /// 저금통 사용 여부
    var hasCashBox: Bool {
        viewModel.walletData?.hasCashBox ?? false
    }
    
    /// 저금통 금액
    var cashBoxAmount: String {
        guard let cashbox = viewModel.walletData?.cashBox,
              self.hasCashBox == true else {
            return ""
        }
        
        return cashbox.amount + " " + cashbox.currency.readableName
        // return cashbox.currency.symbol + " " + cashbox.amount
    }
    
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
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
                WalletMembersPreview(members: members)
                    .onTapGesture {
                        self.viewModel.walletMembersPreviewTapped?(members)
                    }
                
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
    
    /// 저금통 아이콘
    private var cashboxIconImg: some View {
        Circle()
            .fill(Color.moneyTogether.grayScale.baseGray0)
            .frame(width: ComponentSize.leadingImgSize, height: ComponentSize.leadingImgSize)
            .overlay(
                Image("savings").iconStyle(size: 20, padding: 0)
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
}

//#Preview {
////    WalletHomeViewController()
////    return WalletProfileView(wallet: Wallet.createDummyData())
//}
