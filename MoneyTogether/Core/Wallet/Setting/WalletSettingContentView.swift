//
//  WalletSettingContentView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/17/25.
//

import Foundation
import SwiftUI

struct WalletSettingContentView: View {
    @ObservedObject var viewModel: WalletViewModel
    
    enum SettingSheetType: Identifiable {
        case startDay
        case baseCurrency
        
        var id: String {
            switch self {
            case .startDay:     return "startDay"
            case .baseCurrency: return "baseCurrency"
            }
        }
    }
    
    @State private var isNotiOn: Bool = true
    @State private var settingSheetType: SettingSheetType?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack(alignment: .topTrailing) {
                    WalletProfileSettingsView(viewModel: viewModel)
                    
                    walletProfieEditButton
                        .offset(x: -8, y: 8)
                }
                
                VStack(spacing: 4) {
                    startDaySettingRow
                    baseCurrencyRowTrailingView
                    categorySettingRow
                    notificationSettingRow
                }
                .padding(.horizontal, Layout.side)
                .padding(.vertical, 12)
                .background(Color.moneyTogether.background)
                .cornerRadius(Radius.large)
                .shadow(color: .moneyTogether.grayScale.baseGray30, radius: 5, x: 0, y: 5)
                
                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal, Layout.side)
        }
        .sheet(item: $settingSheetType) { item in
            switch item {
            case .startDay:
                WalletStartDayPickerView(selectedDay: 1, onDone: { selectedDay in
                    self.viewModel.startDay = selectedDay
                    print(#fileID, #function, #line, "selected start day: \( self.viewModel.startDay)")
                })
                .presentationDetents([.fraction(0.4)])
            case .baseCurrency:
                CurrencyTypePickerViewControllerWrapper(onSelect: { newValue in
                    self.viewModel.baseCurrency = newValue
                })
                .presentationDetents([.medium])
            }
        }
    }
    
    /// 지갑 프로필 편집 버튼
    var walletProfieEditButton: some View {
        Button(action: {
            print(#fileID, #function, #line, "navigate to wallet profile edit page")
            self.viewModel.walletEditBtnTapped?()
        }, label: {
            Image("more_horiz").iconStyle()
        })
    }
    
    /// 월 시작일 Row
    var startDaySettingRow: some View {
        createSettingRow(title: "월 시작일", trailingView: {
            createRowTrailingView(contentText: "\(self.viewModel.startDay)일")
        }, tabAction: {
            // 월 시작일 선택 모달 띄우기
            self.settingSheetType = .startDay
#warning("TODO: 로컬 데이터에 저장")
        })
    }
    
    /// 기본 통화 Row
    var baseCurrencyRowTrailingView: some View {
        createSettingRow(title: "기본 통화", trailingView: {
            createRowTrailingView(contentText: "\(self.viewModel.baseCurrency.displayName)")
        }, tabAction: {
            // 기본 통화 선택 모달 띄우기
            self.settingSheetType = .baseCurrency
#warning("TODO: 기본 통화 서버랑 연결")
        })
    }

    /// 카테고리 Row
    var categorySettingRow: some View {
        createSettingRow(title: "카테고리", trailingView: {
            createRowTrailingView(contentText: "    ")
        }, tabAction: {
            print(#fileID, #function, #line, "카테고리 리스트 페이지로 이동")
            self.viewModel.categoriesButtonTapped?()
        })
    }
    
    /// 알림 Row
    var notificationSettingRow: some View {
        createSettingRow(title: "알림", trailingView: {
            Toggle(isOn: $isNotiOn, label: {})
                .tint(Color.moneyTogether.grayScale.baseGray100)
                .padding(.trailing, 12)
        }, tabAction: {
            isNotiOn.toggle()
#warning("TODO: 설정 알림과 연결")
        })
    }
}

// MARK: View Creators
extension WalletSettingContentView {
    /// 세부 설정 row 생성 함수
    /// - Parameters:
    ///   - title: row 타이틀
    ///   - trailingView: row 오른쪽 (trailing)에 들어갈 뷰, Nil 일 경우 empty view가 임의로 들어감
    ///   - tabAction: Row 탭 했을 시, 실행되는 액션 클로져
    /// - Returns: 생성된 Row 뷰
    private func createSettingRow(title: String, trailingView: (() -> some View)?, tabAction: (() -> Void)? = nil) -> some View {
        
        return HStack(alignment: .center) {
            Text(title)
                .foregroundStyle(Color.moneyTogether.label.normal)
                .moneyTogetherFont(style: .b2)
                .frame(height: 40)
                .lineLimit(1)
            
            Spacer()
            
            if let contentTrailingView = trailingView?() {
                contentTrailingView
                    .offset(x: 12)
                    .onTapGesture {
                        tabAction?()
                    }.disabled(tabAction == nil)
            }
        }
    }
    
    /// 세부설정 Row trailing view 생성 함수
    /// [some content] [ > 아이콘 이미지] 형태로 구성됨
    /// - some content: 설정값을 보여주기 위한 텍스트 라벨
    /// - > 아이콘 이미지: 페이지 이동 또는 모달 띄우기가 가능함을 암시하기 위한 이미지
    /// - Parameter contentText: [ some content ]에 들어갈 텍스트
    /// - Returns: 생성된 trailing view
    private func createRowTrailingView(contentText: String) -> some View {
        return HStack(spacing: 8) {
            Text(contentText)
                .foregroundStyle(Color.moneyTogether.label.alternative)
                .moneyTogetherFont(style: .b1)
                .lineLimit(1)
            
            Image("chevron_right")
                .iconStyle(size: 12, foregroundColor: .moneyTogether.label.assistive)
        }
    }
}
