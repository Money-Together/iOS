//
//  MoneyLogsViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/28/25.
//

import Foundation
import SwiftUI

class MoneyLogsViewModel : ObservableObject {
    
    @Published private(set) var selectedDateFilter: Date = Date()
    
    private(set) var moneyLogCellItems: [MoneyLogCellItem] = []
    private(set) var logs: [MoneyLog] = []
    
    func numberOfRows(in section: Int) -> Int {
        return moneyLogCellItems.count
    }
    
    func cellItem(at indexPath: IndexPath) -> MoneyLogCellItem {
        return moneyLogCellItems[indexPath.row]
    }
}

// MARK: Fetch Functions
extension MoneyLogsViewModel {
    /// 서버에서 머니로그 리스트 가져오는 함수
    func fetchLogs() {
        // api 호출
        let dummyData: [MoneyLog] = Array(0..<50).map { idx in
            let dayString = String(format: "%02d", (idx % 20) + 1) // 항상 두 자리로
            var logData = MoneyLog.createDummyData(date: "2025-05-" + dayString)
            logData.transactionType = idx % 3 == 0 ? .spending : .earning
            switch idx % 7 {
            case 1, 4: logData.currency = .eur
            case 2, 5: logData.currency = .usd
            case 3: logData.currency = .jpy
            default: break
            }
            
            return logData
        }
        
        // 데이터 업데이트
        self.logs = dummyData
        
        // 머니로그 테이블뷰 데이터소스 업데이트
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY-MM-dd"
        
        let grouped = Dictionary(grouping: logs) {
            formatter.date(from: $0.date)
        }
            
        let sorted = grouped.sorted {
            guard let date1 = $0.key,
                  let date2 = $1.key else { return false }
            return date1 < date2
        }
        
        self.moneyLogCellItems = sorted.flatMap { (date, logs) -> [MoneyLogCellItem] in
            var items: [MoneyLogCellItem] = []
            
            // 날짜 헤더 먼저 추가
            let dateStr = date?.formattedString(format: "d일 EEEE") ?? ""
            items.append(.date(dateStr))
            
            // 해당 날짜의 로그들 추가
            items.append(contentsOf: logs.map { .moneyLog($0) })
            
            return items
        }
    }
}

// MARK: Date Filter Handling
extension MoneyLogsViewModel {
    func canMoveToNextMonth() -> Bool {
        let current = self.selectedDateFilter
        
        if let nextMonth = current.addingMonth(1),
           !nextMonth.isInFuture() {
            return true
        }
        
        return false
        
    }
    
    func moveToNextMonth() -> Date {
        let current = self.selectedDateFilter
        guard let nextMonth = current.addingMonth(1),
              !nextMonth.isInFuture() else {
            return current
        }
        
        self.selectedDateFilter = nextMonth
        
        return nextMonth
    }
    
    func moveToPreviousMonth() -> Date {
        let current = self.selectedDateFilter
        let prevMonth = current.addingMonth(-1) ?? current
        
        self.selectedDateFilter = prevMonth
        
        return prevMonth
    }
}
