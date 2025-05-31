//
//  WalletProfileSettingsView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/31/25.
//

import Foundation
import SwiftUI


struct WalletProfileSettingsView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    
    @State var showInviteMemberView: Bool = false
    
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
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(walletName)
                .moneyTogetherFont(style: .h6)
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
                
                Spacer()
                
                CTAButton(
                    activeState: .active,
                    buttonStyle: .solid,
                    labelText: "초대하기",
                    labelFontStyle: .b1,
                    buttonHeight: 40,
                    buttonWidth: 100,
                    cornerRadius: Radius.medium,
                    action: {
                        print(#fileID, #function, #line, "kkk")
                        showInviteMemberView = true
                    }
                )
            }.padding(.vertical, 8)
            
            
            if hasCashBox {
                Divider()
                
                HStack(spacing: 8) {
                    cashboxIconImg
                    
                    Text("저금통")
                    
                    Spacer()
                    
                    Text(cashBoxAmount)
                        .moneyTogetherFont(style: .b1)
                        .foregroundStyle(Color.moneyTogether.label.alternative)
                }
            }
        }
        .padding(20)
        .padding(.top, 24)
        .background(Color.moneyTogether.background)
//        .background(Color.yellow)
        .clipShape(RoundedRectangle(cornerRadius: Radius.large))
        .shadow(color: .moneyTogether.grayScale.baseGray30, radius: 5, x: 0, y: 5)
        .sheet(isPresented: $showInviteMemberView, content: {
            InviteMemberView()
                .presentationDetents([.fraction(0.3)])
        })
           
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

#Preview {
    let viewModel = WalletViewModel()
    viewModel.fetchWalletData()
    viewModel.fetchMembers()
    
    return WalletProfileSettingsView(viewModel: viewModel)
}
