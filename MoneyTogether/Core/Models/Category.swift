//
//  Category.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/14/25.
//

import Foundation

struct Category {
    var name: String
    var iconImg: String
    var color: String?
    
    static func createDummyList() -> [Category] {
        var list: [Category] = []
        
        Array(1...50).forEach { idx in
            list.append(Category(name: "카테고리 \(idx)", iconImg: "saving", color: "cccccc"))
        }
        
        return list
    }
}
