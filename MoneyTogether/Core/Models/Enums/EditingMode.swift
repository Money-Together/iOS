//
//  EditingMode.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/3/25.
//

import Foundation

/// 편집 모드
/// - 생성, 수정
enum EditingMode<T> {
    case create
    case update(orgData: T)
    
    var orgData: T? {
        if case let .update(orgData) = self {
            return orgData
        }
        
        return nil
    }
}
