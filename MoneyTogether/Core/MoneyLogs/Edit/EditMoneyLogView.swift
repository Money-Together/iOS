//
//  EditMoneyLogView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/25/25.
//

import Foundation
import SwiftUI

struct EditMoneyLogView : View {
    
    @ObservedObject var viewModel: EditMoneyLogViewModel
    
    @State var selectedType: TransactionType = .spending
    private var settlementSectionTitle: String {
        switch selectedType {
        case .spending: return "입금 정보"
        case .earning: return "정산 정보"
        default: return "자산 및 정산 정보"
        }
    }
    @State var isPrivate: Bool = false
    @State var useCashBox: Bool = false
    
    // MARK: Init

    init(viewModel: EditMoneyLogViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Body
    
    var body: some View {
        ZStack(alignment: .top) {
            CustomNavigationBarView(
                title: "",
                backBtnMode: .modal,
                backAction: {
                    print(#fileID, #function, #line, "뒤로가기")
                    self.viewModel.onBackTapped?()
                }
            ).zIndex(1)

            ScrollView {
                VStack(spacing: 48) {
                    // 거래 타입 슬라이더 피커
                    SliderSegmentedPicker(
                        selection: $selectedType,
                        items: TransactionType.allCases,
                        getTitle: { type in type.description }
                    )
                    
#warning("TODO: 금액 입력 필드")
                    
                    // 거래내역 필수 정보
                    // - 날짜, 카테고리, 나만보기 여부
                    createSectionView(title: "필수 정보", content: {
                        VStack(spacing: 4) {
                            dateRow
                            categoryRow
                            privateRow
                        }
                        .padding(.horizontal, Layout.side)
                        .padding(.vertical, 12)
                        .background(Color.moneyTogether.background)
                        .cornerRadius(Radius.large)
                        .shadow(color: .moneyTogether.grayScale.baseGray30, radius: 5, x: 0, y: 5)
                    })
                    
                    // 메모
                    createSectionView(title: "메모", content: {
                        VStack(spacing: 4) {
#warning("TODO: 메모 입력 필드")
                        }
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .padding(.horizontal, Layout.side)
                        .padding(.vertical, 12)
                        .background(Color.moneyTogether.background)
                        .cornerRadius(Radius.large)
                        .shadow(color: .moneyTogether.grayScale.baseGray30, radius: 5, x: 0, y: 5)
                    })
                    
                    // 자산 및 정산 정보
                    // 거래 타입에 따라 다른 뷰가 보여짐
                    createSectionView(title: settlementSectionTitle, content: {
                        VStack(spacing: 4) {
                            switch selectedType {
                            case .spending: spendingSettlementView  // 정산 정보
                            case .earning: earningSettlementView    // 입금될 자산 정보
                            }
                        }
                        .padding(.horizontal, Layout.side)
                        .padding(.vertical, 12)
                        .background(Color.moneyTogether.background)
                        .cornerRadius(Radius.large)
                        .shadow(color: .moneyTogether.grayScale.baseGray30, radius: 5, x: 0, y: 5)
                    })
                    
                    CTAButton(
                        activeState: .active,
                        buttonStyle: .solid,
                        labelText: "완료", action: {
                            print(#fileID, #function, #line, "머니로그 편집 완료")
                        }
                    ).padding(.top, 40)
                    
                }
                .padding(.horizontal, Layout.side)
                .padding(.top, ComponentSize.navigationBarHeight + 40)
                .padding(.bottom, Layout.bottom)
            }
        }
    }
}

// MARK: Basic Info Row
extension EditMoneyLogView {
    /// 날짜 정보
    /// 선택된 날짜를 보여줌
    /// 탭할 경우, 날짜 선택 모달을 띄워줌
    private var dateRow: some View {
        LabeledContent {
            createRowTrailingView(contentText: nil, placeholder: "필수 사항")
        } label: {
            createRowTitleLabel(title: "날짜")
        }.onTapGesture {
            print(#fileID, #function, #line, "날짜 선택 모달 present")
        }
    }
    
    /// 카테고리 정보
    /// 선택된 카테고리를 보여줌
    /// 탭할 경우, 카테고리 선택 모달을 띄워줌
    private var categoryRow: some View {
        LabeledContent {
            createRowTrailingView(contentText: nil, placeholder: "필수 사항")
        } label: {
            createRowTitleLabel(title: "카테고리")
        }.onTapGesture {
            print(#fileID, #function, #line, "카테고리 선택 모달 present")
        }
    }
    
    /// 나만 보기 정보
    /// 나만보기 여부를 스위치를 통해 선택 가능
    private var privateRow: some View {
        LabeledContent {
            Toggle(isOn: $isPrivate, label: {})
                .tint(Color.moneyTogether.grayScale.baseGray100)
        } label: {
            createRowTitleLabel(title: "나만 보기")
        }
    }
}

// MARK: Settlement View
extension EditMoneyLogView {
    /// 거래 타입이 수입일 경우, 자산 및 정산 정보 섹션 뷰
    /// - 금액이 입급될 자산 선택 Row
    private var earningSettlementView: some View {
        VStack {
            LabeledContent {
                createRowTrailingView(contentText: nil, placeholder: "필수 사항")
            } label: {
                createRowTitleLabel(title: "자산")
            }.onTapGesture {
                print(#fileID, #function, #line, "자산 선택 모달 present")
            }
        }
    }
    
    /// 거래 타입이 지출일 경우, 자산 및 정산 정보 섹션 뷰
    /// - 저금통 사용 여부 선택
    /// - 참여자 및 결제자
    /// - 참여자 별 정산 금액
    /// - 정산하고 남은 금액
    private var spendingSettlementView: some View {
        VStack {
            // 저금통 사용 여부 선택
            LabeledContent {
                Toggle(isOn: $useCashBox, label: {})
                    .tint(Color.moneyTogether.grayScale.baseGray100)
            } label: {
                createRowTitleLabel(title: "저금통을 사용할까요?")
            }
            
            // 참여자 선택
            // 탭하면 참여자 및 결제자 선택 화면으로 이동
            LabeledContent {
                HStack(spacing: 8) {
                    // WalletMembersPreview(members: members)
                    Text("\(self.viewModel.settlementMembers.count) 명")
                        .foregroundStyle(Color.moneyTogether.label.alternative)
                        .moneyTogetherFont(style: .b1)
                    Image("chevron_right")
                        .iconStyle(size: 12, foregroundColor: .moneyTogether.label.assistive, padding: 0)
                }
            } label: {
                createRowTitleLabel(title: "참여자")
            }.onTapGesture {
                // 정산 멤버 선택 화면으로 이동
                self.viewModel.onSelectSettlementMember?(self.viewModel.settlementMembers)
            }
            
            // 참여자 리스트
            // 참여자 별 정산 금액 보여줌, 정산 금액 수정 가능
            ForEach(self.viewModel.settlementMembers, id: \.id) { member in
                let nickanmeText = member.userInfo.nickname + (member.isPayer ? "(결제자)" : "")
                
                LabeledContent {
                    // 멤버 별 정산 금액 - trailing
                    Text("2,000")
                        .foregroundStyle(Color.moneyTogether.label.normal)
                        .moneyTogetherFont(style: .detail2)
                        .frame(height: 40)
                        .lineLimit(1)
                } label: {
                    // 멤버 프로필 이미지 & 닉네임 - leading
                    HStack {
                        ProfileImageView(size: ProfileImgSize.small, imageUrl: member.userInfo.profileImgUrl)
                            .overlay {
                                if member.isPayer {
                                    PayerMark()
                                }
                            }
                        
                        Text(nickanmeText)
                            .foregroundStyle(Color.moneyTogether.label.normal)
                            .moneyTogetherFont(style: .detail2)
                            .frame(height: 40)
                            .lineLimit(1)
                    }
                }.padding(.horizontal, 8)
            }
            
            // 모든 참여자의 정산 금액과 거래내역 금액 간의 차액
            Text("남은 금액: 2,000")
                .foregroundStyle(Color.moneyTogether.label.alternative)
                .moneyTogetherFont(style: .detail2)
                .frame(maxWidth: .infinity, minHeight: 40, alignment: .trailing)
        
        }
    }
}



// MARK: View Creators
extension EditMoneyLogView {
    /// [섹션 타이틀 + 컨텐츠 뷰] 레이아웃으로 섹션 생성하는 함수
    /// - Parameters:
    ///   - title: 타이틀
    ///   - content: 컨텐츠뷰
    /// - Returns: [ 타이틀 + 컨텐츠 뷰 ] 레이아웃으로 구성된 section 뷰
    private func createSectionView(title: String, content: () -> some View) -> some View {
        VStack(alignment: .leading) {
            createSectionTitleLabel(title: title)
            content()
        }
        .frame(maxWidth: .infinity)
    }
    
    /// 섹션 타이틀을 생성하는 함수
    /// - Parameter title: 타이틀
    /// - Returns: 타이틀 헤더 뷰
    private func createSectionTitleLabel(title: String) -> some View {
        Text(title)
            .moneyTogetherFont(style: .b2)
            .foregroundStyle(Color.moneyTogether.label.normal)
            .lineLimit(1)
    }
    
    /// LabeldContent의 타이틀을 생성하는 함수
    /// - Parameter title: 타이틀
    /// - Returns: 타이틀 라벨
    private func createRowTitleLabel(title: String) -> some View {
        Text(title)
            .foregroundStyle(Color.moneyTogether.label.normal)
            .moneyTogetherFont(style: .b2)
            .frame(height: 40)
            .lineLimit(1)
    }
    
    /// Row trailing view 생성 함수
    /// [some content] [ > 아이콘 이미지] 형태로 구성됨
    /// - some content: 선택된 값을 보여주기 위한 텍스트 라벨, 선택된 값이 없을 경우 기본 텍스트(placeholder)를 보여줌
    /// - > 아이콘 이미지: 페이지 이동 또는 모달 띄우기가 가능함을 암시하기 위한 이미지
    /// - Parameter contentText: [ some content ]에 들어갈 텍스트
    /// - Parameter placeholder: content가 없을 경우(nil), 기본적으로 들어가는 텍스트
    /// - Returns: 생성된 trailing view
    private func createRowTrailingView(contentText: String?, placeholder: String = "") -> some View {
        return HStack(spacing: 8) {
            if let content = contentText {
                // 선택된 값
                Text(content)
                    .foregroundStyle(Color.moneyTogether.label.alternative)
                    .moneyTogetherFont(style: .b1)
                    .lineLimit(1)
            } else {
                // placeholder
                Text(placeholder)
                    .foregroundStyle(Color.moneyTogether.label.assistive)
                    .moneyTogetherFont(style: .b2)
                    .lineLimit(1)
            }
            
            // > 아이콘 이미지
            Image("chevron_right")
                .iconStyle(size: 12, foregroundColor: .moneyTogether.label.assistive, padding: 0)
        }
    }
}

#Preview {
    let vm = WalletViewModel()
    vm.fetchWalletData()
    vm.fetchMembers()
    
    return EditMoneyLogView(viewModel: EditMoneyLogViewModel(walletData: vm.walletData!, walletMembers: vm.members))
}

