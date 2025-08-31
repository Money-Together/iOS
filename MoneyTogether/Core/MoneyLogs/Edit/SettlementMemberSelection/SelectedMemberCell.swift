//
//  SelectedMemberCell.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/27/25.
//

import Foundation
import UIKit
import SwiftUI

// MARK: UICollectionViewCell

/// 지갑 멤버 리스트 custom cell
/// SwiftUI 뷰를 호스팅해 UITableView에서 사용할 Cell 구성
class SelectedMemberCell: UICollectionViewCell {
    static let reuseId: String = "SelectedMemberCell"

    func configure(with data: SelectableSettlementMember, onDeselect: (() -> Void)?) {
        self.contentConfiguration = UIHostingConfiguration {
            SelectedMemberCellView(data: data, onDeselect: onDeselect)
        }
        contentView.preservesSuperviewLayoutMargins = false
        contentView.layoutMargins = .zero
    }
}


// MARK: Cell View

// SwiftUI View로 구성된 정산 멤버 선택 Cell
struct SelectedMemberCellView: View {
    
    let cellSize: CGSize = CGSize(width: 80, height: 120)
    
    let profileImgSize: CGFloat = ProfileImgSize.large
    
    
    // 멤버 프로필 이미지 URL
    private var profileImgUrl: String?
    
    // 멤버 닉네임
    private var nickname: String?

    /// 결제자인지 여부
    private var isPayer: Bool
    
    var onDeselect: (() -> Void)?
    
    init(data: SelectableSettlementMember, onDeselect: (() -> Void)?) {
        self.profileImgUrl = data.userInfo.profileImgUrl
        self.nickname = data.userInfo.nickname
        self.isPayer = data.isPayer
        self.onDeselect = onDeselect
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Button(action: {
                print(#fileID, #function, #line, "cancel btn tapped")
                onDeselect?()
            }, label: {
                ProfileImageView(size: profileImgSize, imageUrl: profileImgUrl)
                    .overlay {
                        if isPayer {
                            PayerMark(profileImgSize: profileImgSize, iconSize: 24)
                        }
                        cancelBtnImg
                    }
            })
            
            
            Text(nickname ?? "no name")
                .foregroundStyle(Color.moneyTogether.label.normal)
                .moneyTogetherFont(style: .detail2)
                .lineLimit(1)
                .frame(height: 24, alignment: .topLeading)

        }
        .frame(width: cellSize.width, height: cellSize.height)
    }
    
    var cancelBtnImg: some View {
        let cancelBtnOffset: CGFloat = (profileImgSize / 2) - 8
        
        return Image("cancel")
            .iconStyle(size: 20, foregroundColor: .moneyTogether.label.alternative, padding: 0)
            .opacity(0.7)
            .background(Color.white)
            .cornerRadius(10)
            .padding(10)
            .offset(x: cancelBtnOffset, y: -cancelBtnOffset)
    }
}

#Preview {
    var dummyData: [SelectableSettlementMember] = Array(1...10).map {
        SelectableSettlementMember(userInfo: SimpleUser.init(userId: $0, nickname: "닉네임은최대열자야아", profileImgUrl: nil), isPayer: $0 == 1 ? true : false, isSelected: true)
    }
    
    ScrollView(.horizontal) {
        HStack(spacing: 16) {
            ForEach(dummyData, id: \.id) { data in
                SelectedMemberCellView(
                    data: data,
                    onDeselect: {}
                )
            }
        }
    }
}
