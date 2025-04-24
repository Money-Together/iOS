//
//  TextStyle.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/23/25.
//

import Foundation
import UIKit
import SwiftUI


/// 커스텀 폰트 스타일
enum MoneyTogetherTextStyle {
    case h1, h2, h3, h4, h5, h6, b1, b2, detail1, detail2
    
    private var baseSize: CGFloat {
        switch self {
        case .h1:       return 36
        case .h2:       return 32
        case .h3:       return 24
        case .h4:       return 22
        case .h5:       return 20
        case .h6:       return 18
        case .b1:       return 16
        case .b2:       return 16
        case .detail1:  return 12
        case .detail2:  return 12
        }
    }
    
    private var weight: FontWeight {
        switch self {
        case .b2, .detail2 : .regular
        default: .bold
        }
    }
    
    /// 커스텀 텍스트스타일에 대응하는 UIFont Text Style
    /// dynamic type 적용을 위한 text style 매칭
    private var uiTextStyleForDynamic: UIFont.TextStyle {
        switch self {
        case .h1:       return .largeTitle
        case .h2:       return .title1
        case .h3:       return .title1
        case .h4:       return .title2
        case .h5:       return .title3
        case .h6:       return .title3
        case .b1:       return .headline
        case .b2:       return .body
        case .detail1:  return .caption1
        case .detail2:  return .caption1
        }
    }
    
    /// 커스텀 텍스트스타일에 대응하는 Font Text Style
    /// dynamic type 적용을 위한 text style 매칭
    private var textStyleForDynamic: Font.TextStyle {
        switch self {
        case .h1:       return .largeTitle
        case .h2:       return .title
        case .h3:       return .title
        case .h4:       return .title2
        case .h5:       return .title3
        case .h6:       return .title3
        case .b1:       return .headline
        case .b2:       return .body
        case .detail1:  return .caption
        case .detail2:  return .caption
        }
    }

    
    // SwiftUI 스타일
    var swiftUIFont: Font {
        Font.custom(self.weight.fontName, size: self.baseSize, relativeTo: self.textStyleForDynamic)
    }
    
    // uikit 스타일
    var uikitFont: UIFont {
        let baseFont = UIFont(name: self.weight.fontName, size: self.baseSize)
                        ?? UIFont.systemFont(ofSize: self.baseSize, weight: self.weight.systemUIWeight)
        
        let scaledFont = UIFontMetrics(forTextStyle: self.uiTextStyleForDynamic).scaledFont(for: baseFont)
        
        return scaledFont
    }
}


#if DEBUG

class UIFontTestViewController: UIViewController {
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "text style 테스트 입니다."
        label.textColor = .black
        label.font = .moneyTogetherFont(style: .h6)
        label.clipsToBounds = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.addSubview(testLabel)
        view.backgroundColor = UIColor.moneyTogether.system.red
    }
    
    private func setLayout() {
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150)
        ])
    }
}

struct FontTestView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("text style 테스트")
                .moneyTogetherFont(style: .h1)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.moneyTogether.system.blue)
    }
}


@available(iOS 17, *)
#Preview {
//     return UIFontTestViewController()
    FontTestView()
}

#endif
