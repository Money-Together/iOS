//
//  String+DecimalStyle.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/3/25.
//

import Foundation

extension String {
    
    /// 숫자(decimal digits)와 소수점(point)로만 구성되어 있는지 확인
    /// - Returns: 숫자와 소수점으로만 구성되어 있으면 true
    func isDecimalStyle() -> Bool {
        var validCharacters = CharacterSet.decimalDigits
        validCharacters.insert(".")
        return self.rangeOfCharacter(from: validCharacters.inverted) == nil
    }
    
    /// 숫자 문자열을 decimal style로 변환하는 함수
    /// - decimal style: 숫자 문자열(소수점 가능) + 쉼표(comma)를 포함
    /// - self가 숫자 문자열(숫자와 소수점으로만 구성)이 아닐 경우 self를 리턴
    /// - Returns: decimal style 문자열
    func decimalStyle() -> String {
        // (decimal digits, 소수점) 으로만 구성되어 있는지 확인
        guard self.isDecimalStyle() else {
            return self
        }
        
        // NumberFormatter를 이용해 Decimal 스타일로 변경
        guard let number = Decimal(string: self) else {
            return self
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        
        guard var decimalString = formatter.string(for: number) else {
            return self
        }

        return decimalString
        
    }
    
    /// 숫자 문자열(소수점 가능)을 decimal style로 변환하는 함수
    /// - decimal style: 숫자 문자열(소수점 가능) + 쉼표(comma)를 포함
    /// - 소수점 입력 중("22.", "22.0")처럼 입력값을 보존해야 할 때 사용
    /// - self가 숫자 문자열(숫자와 소수점으로만 구성)이 아닐 경우 self를 리턴
    /// - 예: "1234.5" → "1,234.5", "22.00" → "22.00", "abc" → "abc"
    /// - Returns: decimal style 문자열
    func decimalWithPoint() -> String {
        
        // (decimal digits, 소수점) 으로만 구성되어 있는지 확인
        guard self.isDecimalStyle() else {
            return self
        }
        
        // NumberFormatter를 이용해 Decimal 스타일로 변경
        guard let number = Decimal(string: self) else {
            return self
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        guard var decimalString = formatter.string(for: number) else {
            return self
        }
        
        
        // 소수점 처리를 위해 .(dot)을 입력받은 경우 처리
        
        // 소수점(dot) 기준 split
        let components = self.split(separator: ".", omittingEmptySubsequences: false)
        
        // 소수점 아래 길이
        let fractionalLength = components.count == 2 ? components[1].count : 0
        
        // 소수점 아래 0으로 구성되어 있는지 여부
        let endsWithZero = components.count == 2 && components[1].allSatisfy { $0 == "0" }
        
        // 소수점 .(dot)이 1개 있고, 소수점 이하 숫자 개수가 max 이하 일 때
        // 소수점 아래 입력 살리기
        if components.count == 2
            && formatter.maximumFractionDigits > 0 {
            
            // 소수점 아래 입력을 위해 .(dot)을 입력한 상태
            // ex) "22." -> .(dot) 유지
            if fractionalLength == 0 {
                decimalString += "."
            }
            
            // 소수점 아래에 0을 입력한 상태
            // ex) "22.0", "22.00" -> 0 유지
            else if endsWithZero {
                decimalString += "." + String(repeating: "0", count: min(fractionalLength, formatter.maximumFractionDigits))
            }
        }
        
        return decimalString
    }
}
