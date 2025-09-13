//
//  AuthTarget.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/6/25.
//

import Moya


enum AuthTarget {
    case login(type: SocialLoginType, accessToken: String)
    case refreshToken
    case logout
    
}

extension AuthTarget : BaseTarget {

    var path: String {
        switch self {
        case .login(let type, _)    : return "/auth/\(type.name)"
        case .refreshToken          : return "/auth/refresh"
        case .logout                : return "/auth/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .refreshToken, .logout :
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .login(_, accessToken)    :
            let params : [String: Any] = [ "idToken" : accessToken ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default )
        default:
              return .requestPlain
        }
    }
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        case .login: return .basic
        default: return .bearer
        }
    }
    
}
