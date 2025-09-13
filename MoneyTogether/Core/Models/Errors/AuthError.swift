//
//  AuthError.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/12/25.
//

import Foundation

enum AuthError: LocalizedError {
    case socialLoginFailed(description: String)
    case firebaseFailed
    case serverFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .socialLoginFailed(let messege): return "소셜 로그인에 실패했습니다. - \(messege)"
        case .firebaseFailed: return "파이어베이스 로그인에 실패했습니다."
        case .serverFailed: return "서버 로그인에 실패했습니다."
        case .unknown: return "알 수 없는 오류가 발생했습니다."
        }
    }
}

