//
//  AuthPlugin.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 10/20/25.
//

import Foundation
import Moya

protocol AuthorizedTargetType: TargetType {
  var needsAuth: Bool { get }
}

/// 토큰 헤더를 위한 플러그인
/// 토큰을 보내기 위해서는 사용할 타겟이 AuthorizedTargetType을 채택해야 함
struct AuthPlugin: PluginType {
    private var tokenPair: TokenPair? {
        AuthManager.shared.currentToken
    }

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    guard let token = tokenPair?.accessToken,
          let target = target as? AuthorizedTargetType,
          target.needsAuth else {
        return request
    }

    var request = request
    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    return request
  }
}
