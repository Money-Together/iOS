//
//  SettingView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/14/25.
//

import Foundation
import SwiftUI

enum SettingType: String, CaseIterable, Identifiable {
    case userProfile = "프로필"
    // case noti
    case contact = "문의하기"
    case version = "버전"
    case logout = "로그아웃"
    
    var id: String { self.rawValue }
    
    var title: String { self.rawValue }
    
    var leadingIcon: Image? {
        switch self {
        case .userProfile:  return Image("person")
        // case .noti:         return Image("alarm")
        case .contact:      return Image("help")
        default:            return nil
        }
    }
    
    var onTapped: (() -> Void)? {
        switch self {
        case .userProfile:
            return {
                print(#fileID, #function, #line, "profile edit")
            }
//        case .noti:
//            return {
//                print(#fileID, #function, #line, "noti")
//            }
        case .contact:
            return {
                print(#fileID, #function, #line, "contact")
            }
        case .logout:
            return {
                print(#fileID, #function, #line, "logout")
                AuthManager.shared.logout()
            }
        default: return nil
        }
    }
}

struct SettingView: View {

    let items = SettingType.allCases
    
    var onBack: (() -> Void)?
    
    var body: some View {
        
        ScrollView {
            ForEach(items, id: \.self) { item in
                HStack(spacing: 16) {
                    if let image = item.leadingIcon {
                        image
                            .iconStyle(
                                size: ComponentSize.leadingImgSize / 2,
                                padding: 0
                            )
                    }
                    
                    Text(item.title)
                        .moneyTogetherFont(style: .b2)
                        .foregroundStyle(Color.moneyTogether.label.normal)
                    
                    Spacer()
                }
                .frame(height: ComponentSize.leadingImgSize)
                .padding(.vertical, 4)
                .padding(.horizontal, Layout.side)
                .onTapGesture {
                    item.onTapped?()
                }
            }
        }
        .safeAreaInset(edge: .top, content: {
            CustomNavigationBarView(
                title: "설정",
                backgroundColor: .moneyTogether.background,
                backBtnMode: .push,
                backAction: {
                    self.onBack?()
                }
            )
        })
    }
    
    func createRowView(type: SettingType,
                       trailingView: (() -> some View)? ) -> some View {
        LabeledContent(content: {
            trailingView?()
        }, label: {
            HStack {
                if let image = type.leadingIcon {
                    image
                        .iconStyle(
                            size: ComponentSize.leadingImgSize / 2,
                            padding: ComponentSize.leadingImgSize / 2)
                        .clipShape(.circle)
                }
                
                
                    
            }
        })
    }
}

#Preview {
    SettingView(onBack: {
        print(#fileID, #function, #line, "back")
    })
}
