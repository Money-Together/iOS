//
//  EditMoneyLogView+EarningSettlement.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/21/25.
//

import Foundation
import SwiftUI

extension EditMoneyLogView {
    /// 거래 타입이 수입일 경우, 자산 및 정산 정보 섹션 뷰
    /// - 금액이 입급될 자산 선택 Row
    var earningSettlementView: some View {
        VStack {
            // 저금통 사용 여부 선택
            if self.viewModel.canUseCashbox {
                LabeledContent {
                    Toggle(
                        isOn: Binding(
                            get: {
                                self.viewModel.useCashbox
                            }, set: { newValue in
                                withAnimation(.spring) {
                                    self.viewModel.updateCashboxUsage(newValue)
                                }
                            }
                        ), label: {}
                    ).tint(Color.moneyTogether.brand.primary)
                } label: {
                    createRowTitleLabel(title: "저금통을 충전할까요?")
                }
            }
            
            // 저금통을 사용하지 않을 경우, 개인 자산 선택 가능
            if !self.viewModel.useCashbox {
                assetRow
            }
        }
    }
}
