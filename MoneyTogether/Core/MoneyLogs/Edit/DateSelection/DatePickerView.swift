//
//  DatePickerView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/18/25.
//

import Foundation
import SwiftUI

/// 날짜 선택 모달 뷰
/// - SwiftUI View 로 구현
/// - 달력 형태
struct DatePickerView: View {
    
    // 모달 뷰 닫기
    @Environment(\.dismiss) private var dismiss
    
    // 선택된 날짜
    @State var date: Date
    
    // 선택 완료 시 호출되는 클로저
    var onDone: ((Date) -> Void)?
    
    /// init
    /// - Parameters:
    ///   - date: 날짜 초기값, default = 현재 날짜
    ///   - onDone: 날짜 선택 완료 시 호출되는 클로저
    init(date: Date = Date(),
         onDone: ((Date) -> Void)?) {
        self.date = date
        self.onDone = onDone
    }
    
    var body: some View {
        
        VStack(spacing: 12) {
            // 네비게이션 바
            CustomNavigationBarView(
                title: "날짜를 선택해주세요."
            )
            
            // 달력 형태의 date picker
            DatePicker(
                "",
                selection: $date,
                displayedComponents: [.date]
            )
            // date picker style
            .labelsHidden()
            .datePickerStyle(.graphical)
            .tint(.moneyTogether.brand.primary)
            // date picker layout
            .padding(.horizontal, Layout.side)
            .frame(height: 300)
            // 날짜가 변경될 때, onDone 클로저 실행
            .onChange(of: date) {
                self.onDone?(date)
            }
            
            Spacer()
            
        }
    }
}


#Preview {
    DatePickerView(
        onDone: { date in
            print(#fileID, #function, #line, "selected date: \(date)")
        }
    )
}
