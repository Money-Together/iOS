//
//  GoogleLoginButton.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/9/25.
//

import Foundation
import UIKit

/// 구글 로그인 버튼
final class GoogleLoginButton: UIButton {
    
    /// 구글에서 정해놓은 버튼 타입 & 타입 별 색상
    enum GoogleLoginButtonMode {
        case white
        case black
        case neutral
        
        var backgroundColor: String {
            switch self {
            case .white: return "#FFFFFF"
            case .black: return "#131314"
            case .neutral: return "#F2F2F2"
            }
        }
        
        var strokeColor: String {
            switch self {
            case .white: return "#747775"
            case .black: return "#8E918F"
            case .neutral: return ""
            }
        }
        
        var fontColor: String {
            switch self {
            case .white: return "#1F1F1F"
            case .black: return "#E3E3E3"
            case .neutral: return "#1F1F1F"
            }
        }
    }
    
    private let mode: GoogleLoginButtonMode
    
    private var iconImageView: UIImageView!
       
    private var titleLabelCustom: UILabel!
    
    init(mode: GoogleLoginButtonMode) {
        self.mode = mode
        super.init(frame: .zero)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor(hex: self.mode.backgroundColor)
        self.layer.cornerRadius = 8
        self.layer.borderColor = self.mode.strokeColor == "" ? UIColor.clear.cgColor : UIColor(hex: self.mode.strokeColor).cgColor
        self.layer.borderWidth = 1.0
        
        
        iconImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "google_icon")
            imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            return imageView
        }()
           
        titleLabelCustom = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "구글로 로그인"
            label.textColor = UIColor(hex: self.mode.fontColor)
            label.font = UIFont(name: "Roboto", size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
            return label
        }()
        
        let hstack = UIStackView.makeHStack(
            distribution: .fill,
            alignment: .center,
            spacing: 12,
            subViews: [iconImageView, titleLabelCustom])
        
        self.addSubview(hstack)
        NSLayoutConstraint.activate([
            hstack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hstack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func applyMode() {
        self.backgroundColor = UIColor(hex: self.mode.backgroundColor)
        self.layer.borderColor = self.mode.strokeColor == "" ? UIColor.clear.cgColor : UIColor(hex: self.mode.strokeColor).cgColor
        self.titleLabelCustom.textColor = UIColor(hex: self.mode.fontColor)
    }
}
