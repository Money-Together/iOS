//
//  YearMonthPickerView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/30/25.
//

import Foundation
import SwiftUI

/// 연도와 월을 선택하는 피커 뷰
/// - 연도: 좌우 버튼으로 조절 가능
/// - 월: 4열 그리드 버튼 형식으로 선택
/// - 미래 날짜는 선택 불가
struct YearMonthPickerView: View {
    
    /// 선택 완료 시 호출되는 클로저 (선택된 연도/월을 Date로 반환)
    var onSelect: ((Date) -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    
    /// 현재 선택된 날짜
    @State var selectedDate: Date
    
    /// 현재 선택된 연도
    private var selectedYear: Int {
        selectedDate.year()
    }
    
    /// 현재 선택된 월
    private var selectedMonth: Int {
        selectedDate.month()
    }
    
    /// 이전 연도로 이동 가능한지 여부
    private var moveToPrevYearEnable: Bool {
        selectedYear > YearRange.min
    }

    /// 다음 연도로 이동 가능한지 여부
    private var moveToNextYearEnable: Bool {
        selectedYear < YearRange.max
    }
    
    // 그리드 뷰 세팅
    
    /// 월 표시용 문자열 배열 (1~12월)
    let months: [String] = Calendar.autoupdatingCurrent.shortStandaloneMonthSymbols
    
    /// 그리드 간격
    let spacing: CGFloat = 12
    
    /// 셀 너비 계산값
    let cellWidth: CGFloat
    
    /// LazyVGrid 레이아웃 컬럼 설정
    var columns: [GridItem]
    
    /// 초기화
    /// - 선택된 날짜 및 onSelect 클로저 설정
    /// - 유효하지 않은 연도는 자동으로 YearRange 범위 내로 보정됨
    init(selectedDate: Date, onSelect: ((Date) -> Void)?) {
        self.onSelect = onSelect
        
        // set columns
        let cellCount = 4
        let viewWidth: CGFloat = UIScreen.main.bounds.size.width - (Layout.side * 2)
        self.cellWidth = (viewWidth - ((CGFloat(cellCount) - 1) * spacing)) / CGFloat(cellCount)
        self.columns = Array(repeating: .init(.fixed(cellWidth), spacing: spacing), count: cellCount)
        
        // set selected date
        // YearRange 벗어날 경우, 선택된 연도 보정
        let year = Calendar.autoupdatingCurrent.component(.year, from: selectedDate)
        guard YearRange.contains(year) else {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
            components.year = year < YearRange.min ? YearRange.min : YearRange.max
            self.selectedDate = Calendar.autoupdatingCurrent.date(from: components) ?? Date()
            return
        }
        self.selectedDate = selectedDate
    }
    
    var body: some View {
        VStack {
            //year picker
            yearPicker
                .padding(12)
            
            //month picker
            monthPicker
                .padding(.horizontal)
        }
    }
    
    /// 연도 선택 (좌우 이동 버튼 + 연도 텍스트)
    private var yearPicker: some View {
        HStack {
            // move to previous year button
            Button(action: {
                self.selectedDate = selectedDate.addingYearSafely(-1)
            }, label: {
                Image("arrow_left")
                    .iconStyle(foregroundColor: moveToPrevYearEnable ? .moneyTogether.label.alternative : .moneyTogether.system.inactive)
            }).disabled(!moveToPrevYearEnable)
            
            // selected year text
            Text(String(selectedYear))
                .moneyTogetherFont(style: .b1)
                .foregroundStyle(Color.moneyTogether.label.alternative)
                .padding(.vertical, 10)
                .padding(.horizontal, 4)
            
            // move to next year button
            Button(action: {
                self.selectedDate = selectedDate.addingYearSafely(1)
            }, label: {
                Image("arrow_right")
                    .iconStyle(foregroundColor: moveToNextYearEnable ? .moneyTogether.label.alternative : .moneyTogether.system.inactive)
            }).disabled(!moveToNextYearEnable)
        }
    }
    
    /// 월 선택 그리드 (현재 연도 기준으로 미래 월은 비활성화)
    private var monthPicker: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(months.indices, id: \.self) { idx in
                let month = months[idx]
                let enable: Bool = enableMonth(idx + 1)
                Text(month)
                    .moneyTogetherFont(style: .b2)
                    .foregroundStyle(enable ? Color.moneyTogether.label.alternative : Color.moneyTogether.label.inactive)
                    .frame(width: cellWidth)
                    .padding(.vertical, 12)
                    .background(idx + 1 == selectedMonth && enable ? Color.moneyTogether.grayScale.baseGray20 :  Color.moneyTogether.background)
                    .cornerRadius(Radius.medium)
                    .onTapGesture {
                        if enable {
                            self.done(selectedMonth: idx + 1)
                        }
                    }
            }
        }
    }
    
    /// 주어진 월이 현재 날짜 기준으로 미래인지 여부를 검사
    /// 미래가 아니면 true를 반환 (활성화 가능)
    private func enableMonth(_ month: Int) -> Bool {
        var dateComponent = DateComponents()
        dateComponent.day = 1
        dateComponent.month = month
        dateComponent.year = selectedYear
        let date = Calendar.autoupdatingCurrent.date(from: dateComponent)!
        return !date.isInFuture()
    }
    
    /// 사용자가 월을 선택했을 때 호출되는 함수
    /// - 선택된 연도와 월을 기준으로 날짜를 설정하고 선택 콜백 실행 후 뷰를 닫음
    private func done(selectedMonth: Int) {
        var dateComponent = DateComponents()
        dateComponent.day = 1
        dateComponent.month = selectedMonth
        dateComponent.year = selectedYear
        
        selectedDate = Calendar.autoupdatingCurrent.date(from: dateComponent)!
        self.onSelect?(selectedDate)
        dismiss()
    }
}

#Preview {
    // SelectedDateFilterView(viewModel: MoneyLogsViewModel())
    
    var dateComponent = DateComponents()
    dateComponent.day = 1
    dateComponent.month = 1
    dateComponent.year = 2024
    let date = Calendar.autoupdatingCurrent.date(from: dateComponent)!

    return YearMonthPickerView(selectedDate: date, onSelect: { date in
        print(#fileID, #function, #line, "selected Date: \(date)")
    })
}
