//
//  GridCollectionViewFlowLayout.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/15/25.
//

import Foundation
import UIKit

/// gird layout
/// - ratioHeightToWidth: cell 가로 대비 세로 크기 비율, default = 1.0
/// - numberOfColumns: column 개수, default = 1
/// - spacing: cell 사이 간격 크기, default = 0.0
class GridCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var ratioHeightToWidth = 1.0
    
    var numberOfColumns = 1
    
    var cellSpacing = 0.0 {
        didSet {
            self.minimumLineSpacing = self.cellSpacing
            self.minimumInteritemSpacing = self.cellSpacing
        }
    }
    
    override init() {
        super.init()
        self.scrollDirection = .vertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
