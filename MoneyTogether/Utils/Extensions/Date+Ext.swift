//
//  Date+Ext.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/29/25.
//

import Foundation

extension Date {
    func formattedString(format: String = "yyyy-mm-dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func addingMonth(_ value: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: value, to: self)
    }
    
    func isInFuture() -> Bool {
        return self > Date()
    }
}
