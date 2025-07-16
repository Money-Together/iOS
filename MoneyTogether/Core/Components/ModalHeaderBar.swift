//
//  ModalHeaderBar.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/12/25.
//

import Foundation
import SwiftUI
import UIKit

/// 바텀시트 모달 헤더 바
/// - 취소 버튼, 타이틀, 완료 버튼으로 구성됨
/// - 취소 버튼, 완료 버튼의 경우, 액션 클로져를 정의하지 않을 경우 숨겨짐
/// - 커스텀네비게이션바의 모달 스타일보다 간단하게 사용할 수 있으며 (버튼 추가 불가능), 타이틀 폰트 크기가 더 작아 바텀시트에 사용하기에 적합함
/// - SwiftUI 로 구현된 헤더 바를 호스팅하여 사용
class ModalHeaderView: UIView {
    
    init(title: String, onCancel: (() -> Void)? = nil, onDone: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.configure(title: title, onCancel: onCancel, onDone: onDone)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, onCancel: (() -> Void)?, onDone: (() -> Void)?) {
        let hostingVC = UIHostingController(
            rootView: ModalHeaderBar(title: title, onCancel: onCancel, onDone: onDone)
        )
        
        let view = hostingVC.view.disableAutoresizingMask()
        view.backgroundColor = .clear
        
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
    }
}

/// 바텀시트 모달 헤더 바
/// - 취소 버튼, 타이틀, 완료 버튼으로 구성됨
/// - 취소 버튼, 완료 버튼의 경우, 액션 클로져를 정의하지 않을 경우 숨겨짐
/// - 커스텀네비게이션바의 모달 스타일보다 간단하게 사용할 수 있으며 (버튼 추가 불가능), 타이틀 폰트 크기가 더 작아 바텀시트에 사용하기에 적합함
struct ModalHeaderBar: View {
    
    var title: String
    
    var onCancel: (() -> Void)?
    
    var onDone: (() -> Void)?
    
    var isCancelBtnHidden: Bool {
        onCancel == nil
    }
    
    var isDoneBtnHidden: Bool {
        onDone == nil
    }
    
    init(title: String, onCancel: (() -> Void)? = nil, onDone: (() -> Void)? = nil) {
        self.onCancel = onCancel
        self.onDone = onDone
        self.title = title
    }
    
    var body: some View {
        HStack {
            
            cancelButton

            Spacer()
            
            Text(title)
                .moneyTogetherFont(style: .detail1)
                .foregroundStyle(Color.moneyTogether.label.alternative)
            
            Spacer()
            
            doneButton
            
            
            
        }
        .frame(height: ComponentSize.navigationBarHeight)
        .padding(.horizontal, 12)
        .background(Color.clear)
    }
    
    var cancelButton: some View {
        Button( action: { onCancel?() } ) {
            Image("close")
                .iconStyle(
                    size: 16,
                    foregroundColor: isCancelBtnHidden ? .clear : .moneyTogether.label.alternative,
                    padding: 12)
        }
    }
    
    var doneButton: some View {
        Button( action: { onDone?() } ) {
            Image("circle")
                .iconStyle(
                    size: 20,
                    foregroundColor: isDoneBtnHidden ? .clear : .moneyTogether.label.alternative
                )
        }.disabled(isDoneBtnHidden)
    }
}


#Preview {
    ModalHeaderBar(title: "테스트뷰", onCancel: {
        print(#fileID, #function, #line, "cancel btn tapped")
    }, onDone: {
        print(#fileID, #function, #line, "done btn tapped")
    })
}
