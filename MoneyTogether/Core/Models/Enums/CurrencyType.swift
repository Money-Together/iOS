//
//  CurrencyType.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/14/25.
//

import Foundation

/// 통화 타입
enum CurrencyType: CaseIterable {
    case krw
    case usd
    case eur
    case jpy
    
    /// 통화 타이틀로 사용되는 이름
    /// 통화 코드와 기호로 구성됨 ex. KRW(₩), USD($)
    var displayName: String {
        return "\(self.code)(\(self.symbol))"
    }
    
    /// ISO 4217 Currency Code
    /// 국제 표준화 기구(ISO)에서 정의한 통화 식별 코드야.
    /// ex. KRW, USD
    var code: String {
        switch self {
        case .krw: return "KRW"
        case .usd: return "USD"
        case .eur: return "EUR"
        case .jpy: return "JPY"
        }
    }
    
    /// 통화 단위 이름, 읽을 때 사용하는 이름
    /// ex. 달러, 원
    var readableName: String {
        switch self {
        case .krw: return "원"
        case .usd: return "달러"
        case .eur: return "유로"
        case .jpy: return "엔"
        }
    }
    
    /// 통화 기호
    /// ex. $
    var symbol: String {
        switch self {
        case .krw: return "₩"
        case .usd: return "$"
        case .eur: return "€"
        case .jpy: return "¥"
        }
    }
    
    /// 해당 통화를 사용하는 나라 이름
    var country: String {
        switch self {
        case .krw: return "대한민국"
        case .usd: return "미국"
        case .eur: return "유럽"
        case .jpy: return "일본"
        
        }
    }
    
    
    /// 해당 통화를 사용하는 나라 locale
    /// 금액 입력 시 NumberFormatter 설정을 위함
    var locale: Locale {
        switch self {
        case .krw:
            return Locale(identifier: "ko_KR")
        case .usd:
            return Locale(identifier: "en_US")
        case .eur:
            return Locale(identifier: "fr_FR")
        case .jpy:
            return Locale(identifier: "ja_JP")
        }
    }
    
    /// 해당 통화를 사용하는 나라의 국기 이미지 이름
    var flagImageName: String {
        switch self {
        case .krw: return "flag_kr"
        case .usd: return "flag_us"
        case .eur: return "flag_eu"
        case .jpy: return "flag_jp"
        }
    }
}
