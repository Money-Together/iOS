//
//  UserTarget.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/18/25.
//

import Foundation
import Moya

enum UserTarget {
    case getUserProfile
}

extension UserTarget: BaseTarget, AuthorizedTargetType {
    var needsAuth: Bool {
        true
    }
    
    var path: String {
        switch self {
        case .getUserProfile:
            return "/member/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserProfile:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        default: return .requestPlain
        }
    }
    
    
}
