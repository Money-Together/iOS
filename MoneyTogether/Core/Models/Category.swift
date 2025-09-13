//
//  Category.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/14/25.
//

import Foundation

/// 지갑 카테고리
struct Category {
    var id: Int64?
    var name: String
    var icon: Icon
    var color: PaletteColor
    
    static func createDummyList() -> [Category] {
        var list: [Category] = []
        
        Array(1...50).forEach { idx in
            list.append(
                Category(
                    id: Int64(idx),
                    name: "카테고리 \(idx)",
                    icon: iconPresets[idx % iconPresets.count],
                    color: ColorPalette.presets[idx % ColorPalette.presetCount]
                )
            )
        }
        
        return list
    }
}
