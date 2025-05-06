//
//  CTAUIButton.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/6/25.
//

import Foundation
import UIKit

/// UIKit 에서 사용할 CTA Button
class CTAUIButton: UIButton {
    var title: String
    var style: ButtonStyleType
    var activeState: ButtonState
    var action: () -> Void
    var cornerRadius: CGFloat
    var buttonHeight: CGFloat
    var buttonWidth: CGFloat?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(activeState: ButtonState,
         buttonStyle: ButtonStyleType,
         labelText: String,
         buttonHeight: CGFloat = ComponentSize.ctaBtnHeight,
         buttonWidth: CGFloat? = nil,
         cornerRadius: CGFloat = Radius.small,
         action: (() -> Void)? = nil) {
        
        self.title = labelText
        self.style = buttonStyle
        self.activeState = activeState
        self.action = action ?? { fatalError("CTA button action should be implemented") }
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
        self.cornerRadius = cornerRadius
        
        super.init(frame: .zero)
        
        self.setUI()
        
        self.addAction(UIAction(handler: { _ in 
            self.action()
        }), for: .touchUpInside)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setUI() {
        
        self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        if let btnWidth = self.buttonWidth {
            self.widthAnchor.constraint(equalToConstant: btnWidth).isActive = true
        }
        self.layer.cornerRadius = self.cornerRadius
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .moneyTogetherFont(style: .h6)
        
        self.configureStyle()
       
    }
    
    private func configureStyle() {
        switch (style, activeState) {
        case (.solid, .active):
            configureActiveSolidStyle()
        case (.solid, .inactive):
            self.isEnabled = false
            configureInactiveSolidStyle()
        case (.ghost, .active):
            configureActiveGhostStyle()
        case (.ghost, .inactive):
            self.isEnabled = false
            configureInactiveGhostStyle()
        }
    }
    
    func setButtonEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.activeState = isEnabled ? .active : .inactive
        self.configureStyle()
        
        print(#fileID, #function, #line, "\(activeState), \(style)")
    }
}


// MARK: Configure Functions

extension CTAUIButton {
    
    private func configureActiveSolidStyle() {
        self.setTitleColor(.moneyTogether.label.rNormal, for: .normal)
        
        self.backgroundColor = .moneyTogether.brand.primary
    }
    
    private func configureActiveGhostStyle() {
        self.setTitleColor(.moneyTogether.brand.primary, for: .normal)
        self.backgroundColor = .clear
        
        self.layer.borderColor = UIColor.moneyTogether.brand.primary?.cgColor
        self.layer.borderWidth = 1
    }
    
    private func configureInactiveSolidStyle() {
        self.setTitleColor(.moneyTogether.label.inactive, for: .disabled)
        self.backgroundColor = .moneyTogether.grayScale.baseGray20
    }
    
    private func configureInactiveGhostStyle() {
        self.setTitleColor(.moneyTogether.label.inactive, for: .disabled)
        self.backgroundColor = .clear
        
        self.layer.borderColor = UIColor.moneyTogether.system.inactive?.cgColor
        self.layer.borderWidth = 1
    }
}
