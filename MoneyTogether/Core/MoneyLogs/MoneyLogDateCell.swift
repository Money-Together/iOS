//
//  MoneyLogDateCell.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/29/25.
//

import Foundation
import UIKit

/// 머니로그 리스트 뷰에서 날짜 헤더 뷰
/// 테이블뷰의 sticky behavior을 피하기 위해 cell 형태로 구현
class MoneyLogDateCell: UITableViewCell {
    static let reuseId: String = "moneyLogDateCell"
    
    var dateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.dateLabel = UILabel.make(
            text: "",
            textColor: .moneyTogether.label.assistive,
            font: .moneyTogetherFont(style: .detail1),
            numberOfLines: 1
        )
        self.dateLabel.textAlignment = .left
        
        self.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Layout.side),
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    /// 받아온 날짜로 ui 구성
    /// - Parameter dateString: 날짜 문자열
    func configure(with dateString: String) {
        self.dateLabel.text = dateString
    }
}
