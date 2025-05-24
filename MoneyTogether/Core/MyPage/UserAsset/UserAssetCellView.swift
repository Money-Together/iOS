//
//  UserAssetCellView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/15/25.
//

import Foundation
import UIKit

/*
final class UserAssetCellView: UITableViewCell {
    
    // MARK: Properties
    static let reuseId: String = "userAssetCellView"
    
    private var userAsset: UserAsset?
    
    // MARK: UI Components

    private var nameLabel: UILabel!
    
    private var bioLabel: UILabel!
    
    private var amountLabel: UILabel!
    
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUI()
        self.setLayout()
    }
    
    /// sub views, ui components 세팅하는 함수
    private func setUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        nameLabel = UILabel.make(
            text: "asset name"
        )
//        amountLabel.textAlignment = .left
        
        bioLabel = UILabel.make(
            text: "",
            textColor: .moneyTogether.label.assistive,
            font: .moneyTogetherFont(style: .b2),
            numberOfLines: 1
        )
        
        amountLabel = UILabel.make(
            text: "asset amount",
            numberOfLines: 1
        )
//        amountLabel.textAlignment = .right
        
    }
    
    /// sub views를 추가하고, 레이아웃을 설정하는 함수
    private func setLayout() {
        
        self.addSubview(nameLabel)
        self.addSubview(bioLabel)
        self.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
//            self.heightAnchor.constraint(equalToConstant: 56),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: 12),
            
            amountLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            bioLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bioLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            
            
            
        ])
    }
    
    func updateUI(asset: UserAsset) {
        self.userAsset = asset
        
        self.nameLabel.text = asset.title
        self.amountLabel.text = asset.amount
        self.bioLabel.text = asset.bio
    }
}
 */


import SwiftUI

/// 유저 자산 리스트 cell 뷰
struct UserAssetCellView: View {
    
    // MARK: Properties
    
    private let assetId: UUID
    
    let title: String
    let amountText: String
    let bio: String
    
    var onTapped: ((UUID) -> Void)?
    
    init(userAsset: UserAsset, tapHandler: ((UUID) -> Void)?) {
        self.assetId = userAsset.id
        self.title = userAsset.title
        self.amountText = "\(userAsset.amount) \(userAsset.currencyType.readableName)"
        self.bio = userAsset.bio
        
        self.onTapped = tapHandler
    }
    
    
    // MARK: View layout
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 12) {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .moneyTogetherFont(style: .b1)
                
                Text(amountText)
                    .frame(alignment: .trailing)
                    .moneyTogetherFont(style: .b1)
                    .lineLimit(1)
                    .layoutPriority(1)
                
            }
            
            Text(bio)
                .moneyTogetherFont(style: .b2)
                .foregroundStyle(Color.moneyTogether.label.assistive)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
            
        }
        .onTapGesture {
            self.onTapped?(self.assetId)
        }
    }
}


#Preview {
    UserAssetCellView(userAsset: UserAsset.createDummyData(), tapHandler: { id in
        print(#fileID, #function, #line, "tap asset \(id)")
    })
}

