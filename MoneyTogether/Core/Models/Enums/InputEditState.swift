//
//  InputEditState.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/3/25.
//

import Foundation

/// 사용자의 입력에 따라 발생할 수 있는 편집 상태
/// - empty: 값이 비어 있음
/// - unchanged: 기존 값과 동일
/// - updated: 새로운 값으로 변경됨
/// - invalid: 유효성 검사 실패
enum InputEditState<T: Equatable>: Equatable {
    case empty
    case unchanged
    case updated(newValue: T)
    case invalid

    var newValue: T? {
        if case let .updated(value) = self {
            return value
        }
        return nil
    }
    
    var isUpdated: Bool {
        switch self {
        case .updated:  return true
        default:        return false
        }
    }
}
