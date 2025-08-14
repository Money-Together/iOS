//
//  CustomNavigationBar.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/29/25.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - BackButtonMode

/// 화면 전환 타입에 따른 뒤로가기 버튼 모드
enum BackButtonMode {
    case push
    case modal
    case none
}

//MARK: CustomNavBarItem

/// 커스텀 네비게이션 바에 들어갈 아이템 타입
enum CustomNavBarItem: Identifiable {
    var id: UUID { UUID() }

    case icon(imageName: String, action: () -> Void)
    case pushBack(action: () -> Void)
    case modalBack(action: () -> Void)
    case custom(AnyView)
    
    /// 각 아이템에 해당하는 swiftUI 뷰 렌더링
    @ViewBuilder
    var view: some View {
        switch self {
        case .icon(let imageName, let action):
            Button(action: action) {
                Image(imageName)
                    .iconStyle(size: 20, padding: 10)
            }
        case .pushBack(let action):
            Button(action: action) {
                Image("chevron_left")
                    .iconStyle(size: 20, padding: 10)
            }
        case .modalBack(let action):
            Button(action: action) {
                Image("close")
                    .iconStyle(size: 20, padding: 10)
            }
        case .custom(let view):
            view
        }
    }
}

// MARK: CustomNavigationBarView

/// SwiftUI용 커스텀 네비게이션 바 컴포넌트
struct CustomNavigationBarView: View {
    var title: String
    var backgroundColor: Color
    var leftItems: [CustomNavBarItem] = []
    var rightItems: [CustomNavBarItem] = []
    
    /// init
    /// - Parameters:
    ///   - title: 타이틀, 기본값 = ""
    ///   - backgroundColor: 배경색상, 기본값 = .clear
    ///   - leftItems: 타이틀 왼쪽에 들어갈 바 아이템 리스트, 기본값 = [], (push 타입 백버튼 포함 최대 2개)
    ///   - rightItems: 타이틀 오른쪽에 들어갈 바 아이템 리스트, 기본값 = [],  (modal 타입 백버튼 포함 최대 2개)
    ///   - backBtnMode: 뒤로가기 버튼 모드 (.none, .push, .modal), 기본값 = none
    ///   - backAction: 뒤로가기 버튼 클릭 시 호출되는 클로져, 기본값 = nil
    init(title: String = "",
         backgroundColor: Color = .clear,
         leftItems: [CustomNavBarItem] = [],
         rightItems: [CustomNavBarItem] = [],
         backBtnMode: BackButtonMode = .none,
         backAction: (() -> Void)? = nil ) {
        
        self.title = title
        self.backgroundColor = backgroundColor
        
        // nav bar items 세팅
        // 각 파트에 최대 아이템 개수는 2개
        // push 모드에서는 왼쪽 아이템 1개까지, modal 타입일 경우 오른쪽 아이템 1개까지 추가 가능
        var left = leftItems.prefix(backBtnMode == .push ? 1 : 2)
        var right = rightItems.prefix(backBtnMode == .modal ? 1 : 2)

        // back 버튼 추가
        switch backBtnMode {
        case .push:
            left = [.pushBack(action: { backAction?() })] + left
        case .modal:
            right = right + [.modalBack(action: { backAction?() })]
        default:
            break
        }

        // 최종 nav bar items
        self.leftItems = Array(left)
        self.rightItems = Array(right)
    }

    var body: some View {
        ZStack {
            HStack {
                // left
                HStack(spacing: 4) {
                    ForEach(leftItems.indices, id: \.self) { index in
                        leftItems[index].view
                    }
                }
                
                Spacer()
                
                // right
                HStack(spacing: 4) {
                    ForEach(rightItems.indices, id: \.self) { index in
                        rightItems[index].view
                    }
                }
            }
            .padding(.horizontal, 14)

            // title, center
            Text(title)
                .moneyTogetherFont(style: .h6)
                .foregroundStyle(Color.moneyTogether.label.normal)
        }
        .frame(height: ComponentSize.navigationBarHeight)
        .background(.white)
    }
}


//MARK: CustomNavigationBar

/// uikit용 커스텀 네비게이션 바
class CustomNavigationBar: UIView {
    
    // MARK: Properties
    
    let height: CGFloat = ComponentSize.navigationBarHeight
    
    let backButtonMode: BackButtonMode
    
    var backAction: (() -> Void)?
    
    // MARK: UI Components
    
    var titleLabel: UILabel = {
        let label = UILabel().disableAutoresizingMask()
        label.text = ""
        label.font = .moneyTogetherFont(style: .h6)
        label.textColor = .moneyTogether.label.normal
        
        return label
    }()
    
    /// 타이틀 왼쪽에 들어갈 버튼 스택
    let leftBtnStk = UIStackView.makeHStack(
        distribution: .fill,
        alignment: .center,
        spacing: 4
    )
    
    /// 타이틀 오른쪽에 들어갈 버튼 스택
    let rightBtnStk = UIStackView.makeHStack(
        distribution: .fill,
        alignment: .center,
        spacing: 4
    )
    
    /// 네비게이션 push 스타일 백 버튼
    var pushStyleBackBtn: CustomIconButton!
    
    /// 모달 present 스타일 백 버튼
    var modalStyleBackBtn: CustomIconButton!
    
    
    // MARK: Init & Setup
    
    /// 초기화
    /// - Parameters:
    ///   - title: 타이틀, 기본값 = ""
    ///   - backgroundColor: 배경색상, 기본값 = .clear
    ///   - leftButtons: 타이틀 왼쪽에 들어갈 버튼 리스트, 기본값 = []
    ///   - rightButtons: 타이틀 오른쪽에 들어갈 버튼 리스트, 기본값 = []
    ///   - backBtnMode: 뒤로가기 버튼 모드. 기본값 = none
    ///   - backAction: 뒤로가기 액션 클로져, 기본값 = nil
    init(title: String = "",
         backgroundColor: UIColor? = .clear,
         leftButtons: [UIView] = [],
         rightButtons: [UIView] = [],
         backBtnMode: BackButtonMode = .none,
         backAction: (() -> Void)? = nil) {
        
        self.titleLabel.text = title
        self.backButtonMode = backBtnMode
        self.backAction = backAction
        
        super.init(frame: .zero)
        
        setUI(backgroundColor: backgroundColor)
        setLayout(leftBtns: leftButtons, rightBtns: rightButtons)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        
        // 네비게이션 push 스타일 백 버튼 초기화
        self.pushStyleBackBtn = CustomIconButton(
            iconImage: UIImage(named: "chevron_left"),
            iconSize: 20,
            padding: 10,
            action: { self.doBackAction() }
        )
        
        // 모달 present 스타일 백 버튼 초기화
        self.modalStyleBackBtn = CustomIconButton(
            iconImage: UIImage(named: "close"),
            iconSize: 20,
            padding: 10,
            action: { self.doBackAction() }
        )
        
    }
    
    func setLayout(leftBtns: [UIView], rightBtns: [UIView]) {
        // 백 버튼 모드에 따라 버튼 스택에 버튼 추가
        switch self.backButtonMode {
        case .push:
            self.leftBtnStk.addArrangedSubview(self.pushStyleBackBtn)
            self.addButtonsToLeftStack(buttons: leftBtns)
            self.addButtonsToRightStack(buttons: rightBtns)
        case .modal:
            self.addButtonsToLeftStack(buttons: leftBtns)
            self.addButtonsToRightStack(buttons: rightBtns)
            self.rightBtnStk.addArrangedSubview(self.modalStyleBackBtn)
        default:
            self.addButtonsToLeftStack(buttons: leftBtns)
            self.addButtonsToRightStack(buttons: rightBtns)
        }
        
        self.addSubview(leftBtnStk)
        self.addSubview(titleLabel)
        self.addSubview(rightBtnStk)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height),
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            self.leftBtnStk.heightAnchor.constraint(equalToConstant: ComponentSize.iconBtnSize),
            self.rightBtnStk.heightAnchor.constraint(equalToConstant: ComponentSize.iconBtnSize),
            
            self.leftBtnStk.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            self.leftBtnStk.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.rightBtnStk.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            self.rightBtnStk.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 왼쪽 버튼 스택에 버튼 추가
    /// 스택에 최대 2개의 버튼 가능
    /// - Parameter buttons: 추가할 버튼 뷰 리스트
    private func addButtonsToLeftStack(buttons: [UIView]) {
        print(#fileID, #function, #line, "buttons count: \(buttons.count)")
        let maxCount = backButtonMode == .push ? 1 : 2
        
        buttons.prefix(maxCount).forEach { btn in
            self.leftBtnStk.addArrangedSubview(btn)
        }
    }
    
    /// 오른쪽 버튼 스택에 버튼 추가
    /// 스택에 최대 2개의 버튼 가능
    /// - Parameter buttons: 추가할 버튼 뷰 리스트
    private func addButtonsToRightStack(buttons: [UIView]) {
        let maxCount = backButtonMode == .modal ? 1 : 2
        
        buttons.prefix(maxCount).forEach { btn in
            self.rightBtnStk.addArrangedSubview(btn)
        }
    }
    
}

// MARK: Action

extension CustomNavigationBar {
    func doBackAction() {
        self.backAction?()
    }
}
