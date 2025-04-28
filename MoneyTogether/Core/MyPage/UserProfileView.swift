//
//  UserProfileView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/28/25.
//

import Foundation
import UIKit
import SwiftUI

/// 유저 프로필 뷰
/// 프로필 이미지, 닉네임, 이메일로 구성
class UserProfileView: UIView {
    
    // MARK: Properties
    
    /// 유저 닉네임
    private var nicknameText: String = "nickname" {
        didSet {
            self.nicknameLabel.text = nicknameText
        }
    }
    
    /// 유저 이메일 주소
    private var emailText: String = "email@email.com" {
        didSet {
            self.emailLabel.text = emailText
        }
    }
    
    // MARK: Sub Views
    
    /// 프로필 이미지 뷰
    private let imageView: UIView  = {
        let profileImage = UIHostingController(rootView: ProfileImageView(size: ProfileImgSize.large))
        let imageView = profileImage.view!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: ProfileImgSize.large).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: ProfileImgSize.large).isActive = true
        
        return imageView
    }()
    
    /// 닉네임 라벨
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "nickname"
        label.textColor = UIColor.moneyTogether.label.normal
        label.font = .moneyTogetherFont(style: .h6)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    /// 이메일주소 라벨
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "email@email.com"
        label.textColor = UIColor.moneyTogether.label.assistive
        label.font = .moneyTogetherFont(style: .b2)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    // MARK: Init & Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
        self.setLayout()
    }
    
    /// 레이아웃 세팅
    private func setLayout() {
        let labelVstack = UIStackView(arrangedSubviews: [
            nicknameLabel,
            emailLabel
        ])
        labelVstack.translatesAutoresizingMaskIntoConstraints = false
        labelVstack.axis = .vertical
        labelVstack.distribution = .equalCentering
        labelVstack.alignment = .fill
        labelVstack.spacing = 8
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.addSubview(labelVstack)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: UIScreen().bounds.width - (Layout.side * 2)),
            self.heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor, multiplier: 1),
            
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            labelVstack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 24),
            labelVstack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelVstack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelVstack.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor)
        ])
    }
}


// MARK: update UI
extension UserProfileView {
    
    /// 변경된 데이터로 ui 업데이트
    /// - Parameter newData: 변경된 데이터
    func updateUI(newData: UserProfile) {
        if newData.nickname != self.nicknameText {
            self.nicknameText = newData.nickname
        }
        
        if newData.email != self.emailText {
            self.emailText = newData.email
        }
    }
}
