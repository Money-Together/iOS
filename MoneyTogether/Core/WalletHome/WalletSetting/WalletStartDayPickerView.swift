//
//  WalletStartDayPickerView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/11/25.
//

import Foundation
import SwiftUI

/// 월 시작일 선택 모달 뷰
struct WalletStartDayPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    /// 선택된 시작일
    @State var selectedDay: Int
    
    /// 선택 완료 시 실행되는 클로져
    var onDone: ((Int) -> Void)?
    
    var body: some View {
        VStack {
            // 네비게이션 바
            ModalHeaderBar (
                title: "월 시작일",
                onCancel: {
                    dismiss()
                }, onDone: {
                    onDone?(selectedDay)
                    dismiss()
                }
            )
            
            // 피커
            Picker("Start Day Of Wallet", selection: $selectedDay) {
                ForEach(Array(1...31), id: \.self) { day in
                    Text("\(day) 일").tag(day)
                        .moneyTogetherFont(style: .b2)
                }
            }.pickerStyle(.wheel)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    WalletStartDayPickerView(selectedDay: 10)
}
