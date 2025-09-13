//
//  BaseTarget.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/6/25.
//

import Foundation
import Moya

protocol BaseTarget: TargetType {}

extension BaseTarget {
    var baseURL: URL { URL(string: "http://52.79.250.173:8080")! }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    var authorizationType: Moya.AuthorizationType? {
        return .bearer
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
