//
//  Date+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/29/25.
//

import Foundation

extension Date {
    
    /// 지정된 형식으로 날짜를 문자열로 변환
    /// - Parameter format: 날짜 형식 문자열 (기본값: "yyyy-mm-dd")
    /// - Returns: 지정된 형식의 날짜 문자열
    func formattedString(format: String = "yyyy-mm-dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// 현재 날짜에서 연도 값을 반환
    /// - Returns: 연도 (e.g., 2025)
    func year() -> Int {
        return Calendar.autoupdatingCurrent.component(.year, from: self)
    }
    
    /// 현재 날짜에서 월 값을 반환
    /// - Returns: 월 (1~12)
    func month() -> Int {
        return Calendar.autoupdatingCurrent.component(.month, from: self)
    }
    
    /// 주어진 개월 수만큼 더하거나 뺀 날짜 반환
    /// - Parameter value: 추가할 개월 수 (음수면 이전 달)
    /// - Returns: 계산된 날짜, 실패 시 nil
    func addingMonth(_ value: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: value, to: self)
    }
    
    /// 주어진 개월 수를 더하거나 뺀 날짜 반환 (nil이면 자기 자신 반환)
    /// - Parameter value: 추가할 개월 수
    /// - Returns: 계산된 날짜 또는 현재 날짜
    func addingMonthSafely(_ value: Int) -> Date {
        return self.addingMonth(value) ?? self
    }
    
    func addingYear(_ value: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: value, to: self)
    }
    
    /// 주어진 연도 수를 더하거나 뺀 날짜 반환 (nil이면 자기 자신 반환)
    /// - Parameter value: 추가할 연도 수
    /// - Returns: 계산된 날짜 또는 현재 날짜
    func addingYearSafely(_ value: Int) -> Date {
        return self.addingYear(value) ?? self
    }
    
    /// 현재 날짜가 미래인지 여부 반환
    /// - Returns: 현재 시점보다 이후면 true
    func isInFuture() -> Bool {
        return self > Date()
    }
}
