//
//  SettlementMemberSelectionCell.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/26/25.
//

import Foundation
import UIKit
import SwiftUI

// MARK: UICollectionViewCell

/// 지갑 멤버 리스트 custom cell
/// SwiftUI 뷰를 호스팅해 UITableView에서 사용할 Cell 구성
class SettlementMemberSelectionCell: UICollectionViewCell {
    static let reuseId: String = "SettlemmentMemberCell"

    func configure(with data: SelectableSettlementMember, onIsPayerChanged: ((Bool) -> Void)?, onIsSelectedChanged: ((Bool) -> Void)?) {
        self.contentConfiguration = UIHostingConfiguration {
            SettlementMemberSelectionCellView(
                userInfo: data.userInfo,
                isPayer: Binding(get: { data.isPayer }, set: { newValue in
                    onIsPayerChanged?(newValue)
                }),
                isSelected: Binding(get: { data.isSelected }, set: { newValue in
                    onIsSelectedChanged?(newValue)
                })
            )
        }
        contentView.preservesSuperviewLayoutMargins = false
        contentView.layoutMargins = .zero
//        self.selectionStyle = .none
        contentView.backgroundColor = .clear
    }
}


// MARK: Cell View

// SwiftUI View로 구성된 정산 멤버 선택 Cell
struct SettlementMemberSelectionCellView: View {
    
    // 멤버 프로필 이미지 URL
    var profileImgUrl: String?
    
    // 멤버 닉네임
    var nickname: String?

    /// 결제자인지 여부
    @State private var isPayer: Bool

    /// 정산 참여자인지 여부
    @State private var isSelected: Bool
    
    // Binder
    #warning("고민: Binding 이 방법이 최선인가?")
    @Binding var isPayerBinder: Bool
    @Binding var isSelectedBinder: Bool
    
    // WalletMember 데이터를 받아 뷰 속성 초기화
    init(userInfo: SimpleUser, isPayer: Binding<Bool>, isSelected: Binding<Bool>) {
        self.profileImgUrl = userInfo.profileImgUrl
        self.nickname = userInfo.nickname
        self.isPayer = isPayer.wrappedValue
        self.isSelected = isSelected.wrappedValue
        self._isPayerBinder = isPayer
        self._isSelectedBinder = isSelected
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ProfileImageView(size: ProfileImgSize.small, imageUrl: profileImgUrl)
            Text(nickname ?? "no name")
            Spacer()
            Toggle(isOn: $isPayer, label: {})
                .toggleStyle(.customCheckbox)
            Toggle(isOn: $isSelected, label: {})
                .toggleStyle(.customCheckbox)
        }
        .frame(height: 40)
        .onChange(of: isPayer) {
            self.isPayerBinder = isPayer
        }
        .onChange(of: isSelected) {
            self.isSelectedBinder = isSelected
        }
    }
}
