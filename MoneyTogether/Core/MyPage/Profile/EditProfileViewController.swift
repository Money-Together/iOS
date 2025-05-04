//
//  EditProfileViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/28/25.
//

import Foundation
import UIKit

class EditProfileViewController: UIViewController {
    
    var viewModel: MyPageViewModel
    
    let nicknameTextField = CustomTextField(placeholder: "닉네임을 입력하세요.")
    
    var navigationBar = CustomNavigationBar(title: "프로필 편집",
                                            backBtnMode: .push)
    
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = UIColor.moneyTogether.background
        
        self.navigationBar.backAction = {
            self.viewModel.cancelProfileEdit()
        }
        
        self.nicknameTextField.text = viewModel.profile.nickname
    }
    
    private func setLayout() {
        
        let profileImg = UIHostingController(rootView: ProfileImageView(size: 96))
        let imageView = profileImg.view!.disableAutoresizingMask()
        
        let profileImgEditBtn = CustomIconButton(
            iconImage: UIImage(systemName: "camera"),
            iconColor: .moneyTogether.grayScale.baseGray0,
            backgroundColor: .moneyTogether.grayScale.baseGray40,
            size: 40,
            cornerRadius: 20,
            action: {
                print(#fileID, #function, #line, "profile image edit btn tapped")
            })
        
        let nicknameSectionTitle = UILabel.make(
            text: "닉네임",
            font: .moneyTogetherFont(style: .b1),
            numberOfLines: 1
        )

        view.addSubview(navigationBar)
        view.addSubview(imageView)
        view.addSubview(profileImgEditBtn)
        view.addSubview(nicknameSectionTitle)
        view.addSubview(nicknameTextField)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),

            
            imageView.widthAnchor.constraint(equalToConstant: 96),
            imageView.heightAnchor.constraint(equalToConstant: 96),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            profileImgEditBtn.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -8),
            profileImgEditBtn.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            
            nicknameSectionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            nicknameSectionTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.side),
            nicknameSectionTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            
            nicknameTextField.leadingAnchor.constraint(equalTo: nicknameSectionTitle.leadingAnchor),
            nicknameTextField.trailingAnchor.constraint(equalTo: nicknameSectionTitle.trailingAnchor),
            nicknameTextField.topAnchor.constraint(equalTo: nicknameSectionTitle.bottomAnchor, constant: 12)
        ])
    }
    
}

#if DEBUG

import SwiftUI

#Preview {
    return EditProfileViewController(viewModel: MyPageViewModel())
}

#endif
