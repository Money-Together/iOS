//
//  BaseResponse.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/18/25.
//

import Foundation

protocol BaseResponse : Codable {
    associatedtype domainType
    
    func toDomain() -> domainType
}
