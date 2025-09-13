//
//  EditCategoryView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/31/25.
//

import Foundation
import SwiftUI

struct EditCategoryView: View {
    @ObservedObject var viewModel: EditCategoryViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 48) {
                CategoryImageView(
                    color: viewModel.color.color,
                    iconName: viewModel.icon.name,
                    size: ProfileImgSize.xLarge
                )
                
                TextField(
                    "카테고리 이름",
                    text: $viewModel.name,
                    prompt: Text("카테고리 이름을 입력하세요.")
                )
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .moneyTogetherFont(style: .b1)
                .tint(Color.moneyTogether.brand.primary)
                .background(Color.clear)
                .frame(maxWidth: .infinity, minHeight: 40)
                .cardStyle()
                
                
                VStack(spacing: 4) {
                    colorRow
                    iconRow
                }.cardStyle()
                
                Spacer()
                
                CTAButton(
                    activeState: .active,
                    buttonStyle: .solid,
                    labelText: "완료",
                    action: {
                        self.viewModel.handleDoneButtonTap()
                    }
                )
            }
            .padding(.horizontal, Layout.side)
            .padding(.top, 24)
            .padding(.bottom, Layout.bottom)
            .frame(minHeight: UIScreen.main.bounds.height - ComponentSize.navigationBarHeight - 80)
        }
        // naviagtion bar
        .safeAreaInset(edge: .top) {
            CustomNavigationBarView(
                title: "카테고리 편집",
                backBtnMode: .push,
                backAction: {
                    self.viewModel.handleBackButtonTap()
                }
            )
        }
    }
}

extension EditCategoryView {
    /// 색상 선택 row
    private var colorRow: some View {
        LabeledContent {
            Image("chevron_right")
                .iconStyle(size: 12, foregroundColor: .moneyTogether.label.assistive, padding: 0)
        } label: {
            RowTitle(title: "색상")
        }
        .onTapGesture {
            self.viewModel.onSelectColor?()
        }
    }
    
    /// 아이콘 선택 row
    private var iconRow: some View {
        LabeledContent {
            Image("chevron_right")
                .iconStyle(size: 12, foregroundColor: .moneyTogether.label.assistive, padding: 0)
        } label: {
            RowTitle(title: "아이콘")
        }
        .onTapGesture {
            self.viewModel.onSelectIcon?()
        }
    }
}


#Preview {
    EditCategoryView(viewModel: EditCategoryViewModel())
}
