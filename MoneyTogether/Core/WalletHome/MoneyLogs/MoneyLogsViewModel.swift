//
//  MoneyLogsViewModel.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/28/25.
//

import Foundation

class MoneyLogsViewModel {
    private(set) var logsByDate: [MoneyLogsByDate] = []
    private(set) var logs: [MoneyLog] = []
    
    func numberOfSections() -> Int {
        return logsByDate.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return logsByDate[section].logs.count
    }
    
    func getDate(at section: Int) -> String {
        return logsByDate[section].date
    }
    
    func log(at indexPath: IndexPath) -> MoneyLog {
        return logsByDate[indexPath.section].logs[indexPath.row]
    }
}

// MARK: Fetch Functions
extension MoneyLogsViewModel {
    /// 서버에서 머니로그 리스트 가져오는 함수
    func fetchLogs() {
        // api 호출
        let dummyData: [MoneyLog] = Array(0..<50).map { idx in
            MoneyLog.createDummyData(date: "2025-05-\((idx % 20) + 1)")
        }
        
        // 데이터 업데이트
        self.logs = dummyData
        let grouped = Dictionary(grouping: dummyData) { log in
            log.date
        }
        
        let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "YYYY-MM-D"
        
        let sortedSections = grouped.sorted { lhs, rhs in
            // 날짜 파싱해서 비교
            guard let date1 = formatter.date(from: lhs.key),
                  let date2 = formatter.date(from: rhs.key) else { return false }
            return date1 < date2
        }
        
        self.logsByDate = sortedSections.map { date, logs in
            MoneyLogsByDate(date: date, logs: logs)
        }
    }
}
