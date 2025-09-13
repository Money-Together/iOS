//
//  NetwrorkError.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/6/25.
//

import Foundation
import Moya

enum NetworkError: Error {
    case moya(MoyaError)  // 원본 유지
    case noInternet
    case timeout
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case decodingFailed
    case invalidRequest
    case unknown
    
}
