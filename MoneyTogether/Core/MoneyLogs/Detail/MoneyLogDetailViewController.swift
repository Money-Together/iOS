//
//  MoneyLogDetailViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/18/25.
//

import Foundation
import UIKit
import SwiftUI

struct MoneyLogDetailContentView: View {
    
    private var amountText: String = "$ +10,000"
    
    private var settlementMembers: [SettlementMember] = [
        SettlementMember.createDummyData(isPayer: true, status: SettlementMemberStatus(userStatus: .active, settlementStatus: .completed)),
        SettlementMember.createDummyData(status: SettlementMemberStatus(userStatus: .active, settlementStatus: .pending)),
        SettlementMember.createDummyData(isMe: true, status: SettlementMemberStatus(userStatus: .active, settlementStatus: .pending)),
        SettlementMember.createDummyData(status: SettlementMemberStatus(userStatus: .inactive, settlementStatus: .completed)),
        SettlementMember.createDummyData(status:  SettlementMemberStatus(userStatus: .inactive, settlementStatus: .pending))
    ]
    
    private var overallSettlementStatusStatus: SettlementStatus {
        let members = self.settlementMembers
        if members.allSatisfy({ $0.status.settlementStatus == .completed }) {
            return .completed
        } else if members.contains(where: { $0.status.settlementStatus == .cancelled }) {
            return .cancelled
        } else {
            return .pending
        }
    }
    
    private var overallSettlementStatusDescription: String {
        switch overallSettlementStatusStatus {
        case .completed:    
            return "모든 정산이 완료되었어요!"
        case .pending:
            let leftAmount: Decimal = self.settlementMembers
                .filter { $0.status.settlementStatus == .pending }
                .compactMap { Decimal(string: $0.amount.replacingOccurrences(of: ",", with: "")) }
                .reduce(Decimal(0), +)
            return "남은 금액: \(leftAmount)"
        case .cancelled:    return ""
        }
    }
    
    private var isPrivate: Bool = true
    
    private var didUseCaseBox: Bool = true
    
    private var isMemoVisible: Bool = true
    
    private var isSettlementInfoVisible: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 태그 나열
            // 수입/지출, 나만보기 여부, 저금통 사용여부 표시
            HStack(spacing: 8) {
                createTagTile(text: "수입")
                
                if isPrivate {
                    createTagTile(text: "나만보기")
                }
                
                if didUseCaseBox {
                    createTagTile(contentView: {
                        HStack {
                            Image("savings")
                                .iconStyle(size: 16, foregroundColor: Color.moneyTogether.label.alternative, padding: 0)
                            Text("저금통")
                        }
                    })
                }
            }
            .foregroundStyle(Color.moneyTogether.label.alternative)
            .moneyTogetherFont(style: .detail2)
            
            Text(amountText)
                .foregroundStyle(Color.moneyTogether.label.normal)
                .moneyTogetherFont(style: .h4)
                .padding(.bottom, 12)
            
            
            // 기본 정보
            VStack(spacing: 12) {
                createTransactionInfoRow(title: "날짜", content: "2025.07.18")
                createTransactionInfoRow(title: "카테고리", trailingView: {
                    HStack(spacing: 8) {
                        Circle().frame(width: 24)
                        Text("카테고리 이름")
                    }
                })
                createTransactionInfoRow(title: "자산", content: "2025.07.18")
            }
            
            if isMemoVisible {
                Divider()
                
                Text("메모가 있다면 어쩌구 저쩌구")
                    .foregroundStyle(Color.moneyTogether.label.alternative)
                    .moneyTogetherFont(style: .b2)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            // 정산 정보
            if isSettlementInfoVisible {
                Divider()
                
                // 저금통 사용했을 시
                if didUseCaseBox {
                    HStack {
                        Image("savings")
                            .iconStyle(size: ComponentSize.leadingImgSize / 2, padding: ComponentSize.leadingImgSize / 4)
                            .background(Color.moneyTogether.grayScale.baseGray20)
                            .clipShape(.circle)
                            /*.background(Circle().stroke(Color.moneyTogether.brand.primary, lineWidth: 1))*/
                            
                        Text("저금통을 사용했어요!")
                            .foregroundStyle(Color.moneyTogether.label.normal)
                            .moneyTogetherFont(style: .b2)
                    }
                }
                
                VStack(spacing: 12) {
                    // 정산 멤버 리스트
                    ForEach(self.settlementMembers, id: \.id) { settlementMember in
                        createSettlementInfoRow(settlementMember)
                    }
                    
                    // 정산 현황
                    Text(overallSettlementStatusDescription)
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                        .foregroundStyle(Color.moneyTogether.label.alternative)
                        .moneyTogetherFont(style: .detail1)
                }
            }
            
        }.padding(.horizontal, Layout.side)
    }
}

// MARK: View Creators
extension MoneyLogDetailContentView {
    private func createTagTile(text: String) -> some View {
        createTagTile(contentView: {
            Text(text)
                .foregroundStyle(Color.moneyTogether.label.alternative)
                .moneyTogetherFont(style: .detail2)
        })
    }
    
    private func createTagTile(contentView: () -> some View) -> some View {
        contentView()
            .padding(.horizontal, 16)
            .frame(height: 32)
            .background(Color.moneyTogether.grayScale.baseGray20)
            .clipShape(.capsule(style: .circular))
    }
    
    
    private func createTransactionInfoRow(title: String, trailingView: (() -> some View)?) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Color.moneyTogether.label.alternative)
                .moneyTogetherFont(style: .b2)
            
            Spacer()
            
            if let trailing = trailingView {
                trailing()
            }
        }
    }
    
    private func createTransactionInfoRow(title: String, content: String) -> some View {
        createTransactionInfoRow(title: title) {
            Text(content)
                .foregroundStyle(Color.moneyTogether.label.alternative)
                .moneyTogetherFont(style: .b2)
        }
    }
    
    private func createSettlementStatusTile(status: SettlementMemberStatus, isMe: Bool) -> some View {
        let userStatus = status.userStatus
        let settlementStatus = status.settlementStatus
        let isSettleButtonEnabled: Bool = userStatus == .active && settlementStatus == .pending && isMe
        
        var statusTileColor: Color? = Color.moneyTogether.grayScale.baseGray20
        if userStatus == .active && settlementStatus == .completed {
            statusTileColor = Color.moneyTogether.system.blue.opacity(0.4)
        }
        if isSettleButtonEnabled {
            statusTileColor = Color.moneyTogether.brand.primary
        }
        
        var statusTextColor = userStatus == .active
        ? (isSettleButtonEnabled
           ? Color.moneyTogether.label.rNormal : Color.moneyTogether.label.alternative)
        : Color.moneyTogether.label.inactive
        
        return Text(isSettleButtonEnabled ? "정산하기" : settlementStatus.description)
            .foregroundStyle(statusTextColor)
            .moneyTogetherFont(style: .b2)
            .padding(.horizontal, 16)
            .frame(height: 40)
            .background(statusTileColor)
            .clipShape(.capsule(style: .circular))
    }
    
    private func createSettlementInfoRow(_ data: SettlementMember) -> some View {
        
        let nickname = data.userInfo.nickname
        let profileImg = data.userInfo.profileImgUrl
        let isPayer = data.isPayer
        let isMe = data.isMe
        let amount = data.amount
        let userStatus = data.status.userStatus
        let settlementStatus = data.status.settlementStatus
        let isSettleButtonEnabled: Bool = userStatus == .active && settlementStatus == .pending && isMe
        
        return HStack(spacing: 12) {
            ProfileImageView(size: ComponentSize.leadingImgSize, imageUrl: profileImg)
                .overlay {
                    if userStatus == .inactive {
                        Circle()
                            .foregroundStyle(Color.moneyTogether.grayScale.baseGray0.opacity(0.7))
                            .frame(width: ComponentSize.leadingImgSize)
                    }
                    
                    if isPayer {
                        Image("crown")
                            .iconStyle(size: 20, foregroundColor: .yellow, padding: 0)
                            .offset(y: -(ComponentSize.leadingImgSize / 2) - 2)
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(amount)
                    .foregroundStyle(userStatus == .active ? Color.moneyTogether.label.normal : Color.moneyTogether.label.inactive)
                    .moneyTogetherFont(style: .b1)
                Text(nickname + (isPayer ? " (결제자)" : ""))
                    .foregroundStyle(userStatus == .active ? Color.moneyTogether.label.alternative : Color.moneyTogether.label.inactive)
                    .moneyTogetherFont(style: .detail2)
            }
            
            Spacer()
            
            Button(action: {
                print(#fileID, #function, #line, "정산 액션 연결하기")
            }, label: {
                createSettlementStatusTile(status: data.status, isMe: isMe)
            }).disabled(!isSettleButtonEnabled)
            
        }
    }
}

#Preview {
    MoneyLogDetailContentView()
}


class MoneyLogDetailViewController: UIViewController {
    
    // MARK: Sub Views
    private var navigationBar: CustomNavigationBar!
    
    private var contentView: UIView!

    // MARK: Init & Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    /// view & sub views UI 설정
    private func setUI() {
        self.view.backgroundColor = UIColor.moneyTogether.background
        
        // 네비게이션 바
        self.navigationBar = CustomNavigationBar(
            title: "",
            backBtnMode: .push,
            backAction: {
                print(#fileID, #function, #line, "뒤로가기")
            }
        )
        
        // Content View
        let hostingVC = UIHostingController(rootView: MoneyLogDetailContentView())
        self.contentView = hostingVC.view.disableAutoresizingMask()
     
        
        // add subviews
        self.view.addSubview(navigationBar)
        self.view.addSubview(contentView)
        
    }
    
    /// sub views 레이아웃 설정
    private func setLayout() {
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 24),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}


#if DEBUG

import SwiftUI

#Preview {
    return MoneyLogDetailViewController()
}

#endif
