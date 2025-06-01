//
//  YearRange.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/30/25.
//

import Foundation

/// 유효한 연도 범위
/// - 최소값은 2000년, 최대값은 현재 연도
enum YearRange {
    static let min = 2000
    static var max: Int {
        Calendar.current.component(.year, from: Date())
    }
    
    static func contains(_ year: Int) -> Bool {
        (min...max).contains(year)
    }
}
