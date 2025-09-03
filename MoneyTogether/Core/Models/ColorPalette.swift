//
//  ColorPalette.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/1/25.
//

import Foundation
import SwiftUI
import UIKit

/// 팔레트에 저장될 색상 하나
struct PaletteColor: Identifiable, Equatable, Hashable {
    let id: UUID
    var hex: String         // 예: "#cccccc"
    var color: Color        // SwiftUI용 Color
    var uiColor: UIColor    // UIKit용 Color

    init(hex: String) {
        self.id = UUID()
        self.hex = hex
        self.color = Color(hex: hex)
        self.uiColor = UIColor(hex: hex)
    }
}

/// 전체 색상 팔레트
struct ColorPalette {
    
    /// 프리셋 색상 코드
    static let presetHexCodes = [
        "EEEEEE", "DDDDDD", "CCCCCC", "9A9A9A", "676767",
        
        // pink
        "#F7DCDA", "#F4C4C7", "#E5AFB3", "#D7A3A2", "#CCA1A2",
        // yellow
        "#F5EFDD", "#F3E6C4", "#E4D6B2", "#D6CDA2", "#CCC4A1",
        // orange
        "#F8E9DC", "#F2DAC4", "#E4C4AE", "#D5BAA4", "#CEB5A2",
        // green
        "#F1F5DB", "#DDE7CC", "#BACCA6", "#AFBF89", "#A2B68B",
        //skyblue
        "#D3E3EA", "#C2D3DD", "#ADCBD5", "#A6BBC6", "#9DAEBF",
        // blue
        "#D2D6EB", "#C1C6DE", "#AFB5D4", "#A6AAC8", "#9A9BBF",
        // violet
        "#DED3EB", "#CDC2DD", "#BBADD5", "#B5A5C6", "#AC9ABD",
        // purple
        "#EAD3EA", "#DCC3DD", "#CFADD3", "#C6A4C6", "#BE9BBB",
        
        // pink
        "EEBAB7", "E68A8D", "C96068", "AB4543", "9B4443",
        // orange
        "EED3B7", "E6B58A", "C98860", "AB7543", "9B6B43",
        // yellow
        "EEE1B7", "E6CB8A", "C9AF60", "AB9943", "9B8943",
        // green
        "E1E9B7", "BDD299", "7A9B57", "5E7F19", "466D1D",
        // skyblue
        "A8C7D6", "84AABC", "5C93AA", "4B7A90", "355C7D",
        // blue
        "A8AFD6", "848EBC", "5C6BAA", "4B5390", "35387D",
        // violet
        "BAA8D6", "9B84BC", "795CAA", "6B4B90", "57357D",
        // purple
        "D4A8D6", "BA84BC", "A55CAA", "8F4B90", "7D3577",
    ]
    
    // 기본 제공 색상들
    static let presets: [PaletteColor] =  presetHexCodes.map { PaletteColor(hex: $0) }
    
    // 사용자가 추가한 색상들
    static var customColors: [PaletteColor] = []
    
    /// 프리셋 색상 갯수
    static var presetCount: Int {
        ColorPalette.presets.count
    }
    
    static func addCustomColor(_ color: PaletteColor) {
        ColorPalette.customColors.append(color)
    }

    static func removeCustomColor(with id: UUID) {
        ColorPalette.customColors.removeAll { $0.id == id }
    }
}
