//
//  EditMoneyLogView+SpendingSettlement.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/20/25.
//

import Foundation
import SwiftUI

// MARK: SettlementAmountTextField

/// 각 정산 멤버의 정산 금액 입력 필드
struct SettlementAmountTextField: View {
    @Binding var amount: String
    
    @State var previousAmount: String
    
    @State var isEditing: Bool = false
    
    init(amount: Binding<String>) {
        self._amount = amount
        self.previousAmount = amount.wrappedValue
    }
    
    var body: some View {
        TextField(
            "\(previousAmount)",
            text: $amount,
            onEditingChanged: { isEditing in
                self.isEditing = isEditing
            }
        )
        .multilineTextAlignment(.trailing)
        .keyboardType(.decimalPad)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .foregroundStyle(Color.moneyTogether.label.normal)
        .moneyTogetherFont(style: isEditing ? .b1 : .detail2)
        .frame(height: 40)
        .lineLimit(1)
        .onChange(of: isEditing) { before, after in
            print(#fileID, #function, #line, "isEditing changed \(self.isEditing)")
            if before == after { return }
            if after == true {
                // 이전 금액을 placeholder로 보여주고 금액 초기화
                self.previousAmount = self.amount
                self.amount = ""
            } else {
                // 편집 전 금액으로 다시 설정
                if self.amount.isEmpty {
                    self.amount = previousAmount
                    self.previousAmount = self.amount
                }
            }
        }
        .onChange(of: amount) { before, after in
            if before != after {
                // decimal 스타일로
                amount = after.replacingOccurrences(of: ",", with: "").decimalStyle()
            }
        }
    }
}

// MARK: SpendingSettlementView

extension EditMoneyLogView {

    /// 거래 타입이 지출일 경우, 자산 및 정산 정보 섹션 뷰
    /// - 저금통 사용 여부 선택
    /// - 참여자 및 결제자
    /// - 참여자 별 정산 금액
    /// - 정산하고 남은 금액
    var spendingSettlementView: some View {
        VStack {
            // 나만보기 설정 시, 개인 자산 선택 가능
            if self.viewModel.isPrivate {
                assetRow
            }
            
            // 나만보기가 아닐 경우, 정산멤버 설정 가능
            else {
                // 저금통 사용 여부 선택
                if self.viewModel.canUseCashbox {
                    cashboxRow
                }
                
                // 참여자 선택
                // 탭하면 참여자 및 결제자 선택 화면으로 이동
                settlementMembersSelectionRow
                
                // 참여자 리스트
                // 참여자 별 정산 금액 보여줌, 정산 금액 수정 가능
                // 저금통 사용 중일 경우, 정산 금액 수정 불가능
                ForEach(self.viewModel.settlementMembers, id: \.id) { member in
                    createSettlementMemberRow(member: member)
                        .padding(.horizontal, 8)
                }
                
                // 모든 참여자의 정산 금액과 거래내역 금액 간의 차액
                Text("\(self.viewModel.leftAmount)")
                    .foregroundStyle(self.viewModel.isValidLeftAmount ?  Color.moneyTogether.label.alternative : Color.moneyTogether.system.red)
                    .moneyTogetherFont(style: .detail2)
                    .frame(maxWidth: .infinity, minHeight: 40, alignment: .trailing)
            }
        }
    }
}

extension EditMoneyLogView {
    
    /// 저금통 사용 여부 선택
    private var cashboxRow: some View {
        LabeledContent {
            Toggle(isOn: Binding(get: {
                self.viewModel.useCashbox
            }, set: { newValue in
                self.viewModel.updateCashboxUsage(newValue)
            }), label: {})
            .tint(Color.moneyTogether.grayScale.baseGray100)
        } label: {
            createRowTitleLabel(title: "저금통을 사용할까요?")
        }
    }
    
    /// 정산 멤버 수 & 선택화면 이동
    private var settlementMembersSelectionRow: some View {
        LabeledContent {
            HStack(spacing: 8) {
                // WalletMembersPreview(members: members)
                Text("\(self.viewModel.settlementMembers.count) 명")
                    .foregroundStyle(Color.moneyTogether.label.alternative)
                    .moneyTogetherFont(style: .b1)
                Image("chevron_right")
                    .iconStyle(size: 12, foregroundColor: .moneyTogether.label.assistive, padding: 0)
            }
        } label: {
            createRowTitleLabel(title: "참여자")
        }.onTapGesture {
            // 정산 멤버 선택 화면으로 이동
            self.viewModel.onSelectSettlementMember?(self.viewModel.settlementMembers)
        }
    }
    
    /// 정산 멤버 (멤버 프로필 + 정산금액) row 생성
    private func createSettlementMemberRow(member: SettlementMember) -> some View {
        let nickanmeText = member.userInfo.nickname + (member.isPayer ? "(결제자)" : "")
        
        return LabeledContent {
            // 멤버 별 정산 금액 - trailing
            SettlementAmountTextField(
                // 정산 멤버의 정산 금액
                amount: Binding(
                    get: { member.amount},
                    set: { newValue in
                        self.viewModel.updateSettlementMemberAmount(of: member, with: newValue)
                    }
                )
            ).disabled(!self.viewModel.canEditSettlementAmount) // 저금통 사용 시, 금액 수정 불가
        } label: {
            // 멤버 프로필 이미지 & 닉네임 - leading
            HStack {
                ProfileImageView(size: ProfileImgSize.small, imageUrl: member.userInfo.profileImgUrl)
                    .overlay {
                        if member.isPayer {
                            PayerMark()
                        }
                    }
                
                Text(nickanmeText)
                    .foregroundStyle(Color.moneyTogether.label.normal)
                    .moneyTogetherFont(style: .detail2)
                    .frame(height: 40)
                    .lineLimit(1)
            }
        }
    }
}
