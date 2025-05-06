//
//  EditProfileViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/28/25.
//

import Foundation
import UIKit

/// 유저 프로필 수정 뷰
class EditProfileViewController: UIViewController {
    
    var viewModel: EditProfileViewModel
    
    // MARK: Sub Views
    
    let navigationBar = CustomNavigationBar(title: "프로필 편집",
                                            backBtnMode: .push)
    
    let nicknameTextField = CustomTextField(placeholder: "닉네임을 입력하세요.")
    
    let nicknameValidationLabel = UILabel.make(
        text: "* 최소 2자 ~ 최대 10자, 특수문자 불가능",
        textColor: .moneyTogether.label.normal,
        font: .moneyTogetherFont(style: .detail2),
        numberOfLines: 1
    )
    
    let completeButton = CTAUIButton(activeState: .inactive,
                                     buttonStyle: .solid,
                                     labelText: "완료")
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setUI()
        setLayout()
        setBindings()
    }
}


// MARK: Setup
extension EditProfileViewController {
    
    /// sub views, ui components 세팅하는 함수
    private func setUI() {
        view.backgroundColor = UIColor.moneyTogether.background
        
        // navigation bar
        self.navigationBar.backAction = {
            self.viewModel.cancelProfileEdit()
        }
        
        // nickname field
        self.nicknameTextField.text = viewModel.orgData.nickname
        self.nicknameTextField.delegate = self
        
        // complete buton
        self.completeButton.action = {
            self.viewModel.completeProfileEdit(nickname: self.nicknameTextField.text ?? "")
            
        }
    }
    
    /// sub views를 추가하고, 레이아웃을 설정하는 함수
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
        view.addSubview(nicknameValidationLabel)
        view.addSubview(completeButton)
        
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
            nicknameTextField.topAnchor.constraint(equalTo: nicknameSectionTitle.bottomAnchor, constant: 12),
            
            nicknameValidationLabel.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor, constant: 2),
            nicknameValidationLabel.trailingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor),
            nicknameValidationLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 4),
            
            completeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.side),
            completeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    /// 뷰모델과 데이터 바인딩 설정하는 함수
    private func setBindings() {
        viewModel.isCompleteBtnEnable.bind{ isEnable in
            self.completeButton.setButtonEnabled(isEnable)
        }
        
        viewModel.isErrorAlertVisible.bind { isVisible in
            guard isVisible else { return }
            
            self.showErrorAlert(title: "프로필 수정에 실패했어요",
                                message: "입력한 내용과 네트워크를 확인해주세요.")
        }
    }
}

// MARK: Event Handler
extension EditProfileViewController {
    /// 프로필 수정 시 에러 발생했을 경우, 에러 Alert 띄우기
    func showErrorAlert(title: String = "프로필 수정에 실패했어요",
                        message: String = "입력한 내용과 네트워크를 확인해주세요.") {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(title: "확인", style: .default, handler: nil)
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Text Field Event Handler
extension EditProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        var updatedText = currentText
        
        // updatedText 설정
        if let textRange = Range(range, in: currentText) {
            updatedText = currentText.replacingCharacters(in: textRange, with: string)
        }
        
        // 유효성 확인
        // 유효성메세지 & 완료 버튼 뷰 업데이트
        let isUpdated = viewModel.isNicknameUpdated(updatedText)
        let isValid = viewModel.validateNickname(value: updatedText)
        
        self.configureNicknameValidationLabel(isUpdated: isUpdated, isValid: isValid)
        
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let input = textField.text ?? ""
        
        let isUpdated = viewModel.isNicknameUpdated(input)
        let isValid = viewModel.validateNickname(value: input)
        
        // 유효성 확인
        // 유효성메세지 & 완료 버튼 뷰 업데이트
        self.configureNicknameValidationLabel(isUpdated: isUpdated, isValid: isValid)
    }
    
    /// 닉네임 유효성 메세지 뷰 업데이트하는 함수
    /// 닉네임 입력값 변경 여부 & 유효성 여부에 따라 유효성 메세지와 색상을 변경
    private func configureNicknameValidationLabel(isUpdated: Bool, isValid: Bool) {
        
        // 닉네임 입력값이 바뀌지 않았다면, 초기 메세지 유지
        if isUpdated == false {
            self.nicknameValidationLabel.text = "* 최소 2자 ~ 최대 10자, 특수문자 불가능"
            self.nicknameValidationLabel.textColor = .moneyTogether.label.normal
            
            return
        }
        
        // 업데이트 되었고 유효하면, 사용 가능한 닉네임
        if isValid {
            self.nicknameValidationLabel.text = "* 사용 가능한 닉네임입니다."
            self.nicknameValidationLabel.textColor = .moneyTogether.system.green
        }
        
        // 업데이트 되었고 유효하지 않다면, 에러 색상으로 표시
        else {
            self.nicknameValidationLabel.text = "* 최소 2자 ~ 최대 10자, 특수문자 불가능"
            self.nicknameValidationLabel.textColor = .moneyTogether.system.red
        }
    }
}

#if DEBUG

import SwiftUI

#Preview {
    EditProfileViewController(viewModel: EditProfileViewModel(orgData: UserProfile(nickname: "test", email: "")))
}

#endif
