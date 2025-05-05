//
//  ColorSystem.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/23/25.
//

import Foundation
import UIKit
import SwiftUI


extension Color {
    /// money together 앱에서 사용하는 컬러시스템, 색상 팔레트
    /// swiftUI 용
    static let moneyTogether = MoneyTogetherColor()
}

extension UIColor {
    /// money together 앱에서 사용하는 컬러시스템, 색상 팔레트
    /// UIKit 용
    static let moneyTogether = MoneyTogetherUIColor()
}

// MARK: SwiftUI Color
struct MoneyTogetherColor {
    
    let brand = Brand()
    let grayScale = GrayScale()
    let system = System()
    let background = Color("background")
    let label = Label()
    let line = Line()
    
    struct Brand {
        let primary     = Color("brand_primary")
    }
    
    struct GrayScale {
        let baseGray100  = Color("gray100")
        let baseGray80   = Color("gray80")
        let baseGray70   = Color("gray70")
        let baseGray50   = Color("gray50")
        let baseGray40   = Color("gray40")
        let baseGray30   = Color("gray30")
        let baseGray20   = Color("gray20")
        let baseGray10   = Color("gray10")
        let baseGray0    = Color("gray0")
    }
    
    struct System {
        let inactive     = Color("system_inactive")
        let red          = Color("system_point_red")
        let green        = Color("system_point_green")
        let blue         = Color("system_point_blue")
    }
    
    struct Label {
        let normal       = Color("label_normal")
        let alternative  = Color("label_alternative")
        let assistive    = Color("label_assistive")
        let inactive     = Color("label_inactive")
        let rNormal      = Color("label_r_normal")
    }
    
    struct Line {
        let normal       = Color("line_normal")
        let alternative  = Color("line_alternative")
        let rNormal      = Color("line_r_normal")
    }
}
    
// MARK: UIKit Color
struct MoneyTogetherUIColor {
    
    let brand = UIBrand()
    let grayScale = UIGrayScale()
    let system = UISystem()
    let background = UIColor(named: "background")
    let label = UILabel()
    let line = UILine()
    
    struct UIBrand {
        let primary     = UIColor(named: "brand_primary")
    }
    
    struct UIGrayScale {
        let baseGray100 = UIColor(named: "gray100")
        let baseGray80  = UIColor(named: "gray80")
        let baseGray70  = UIColor(named: "gray70")
        let baseGray50  = UIColor(named: "gray50")
        let baseGray40  = UIColor(named: "gray40")
        let baseGray30  = UIColor(named: "gray30")
        let baseGray20  = UIColor(named: "gray20")
        let baseGray10  = UIColor(named: "gray10")
        let baseGray0   = UIColor(named: "gray0")
    }
    
    struct UISystem {
        let inactive     = UIColor(named: "system_inactive")
        let red          = UIColor(named: "system_point_red")
        let green        = UIColor(named: "system_point_green")
        let blue         = UIColor(named: "system_point_blue")
    }
    
    struct UILabel {
        let normal       = UIColor(named: "label_normal")
        let alternative  = UIColor(named: "label_alternative")
        let assistive    = UIColor(named: "label_assistive")
        let inactive     = UIColor(named: "label_inactive")
        let rNormal      = UIColor(named: "label_r_normal")
    }
    
    struct UILine {
        let normal       = UIColor(named: "line_normal")
        let alternative  = UIColor(named: "line_alternative")
        let rNormal      = UIColor(named: "line_r_normal")
    }
}

#if DEBUG

class UITestViewController: UIViewController {
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "color system 테스트 입니다."
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
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

struct TestView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("color system 테스트")
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.moneyTogether.system.blue)
    }
}


@available(iOS 17, *)
#Preview {
    // return UITestViewController()
    TestView()
}

#endif
