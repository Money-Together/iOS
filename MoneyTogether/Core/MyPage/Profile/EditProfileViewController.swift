//
//  EditProfileViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/28/25.
//

import Foundation
import UIKit
import PhotosUI

/// 유저 프로필 수정 뷰
class EditProfileViewController: UIViewController {
    
    var viewModel: EditProfileViewModel
    
    private let profileImgSize = ProfileImgSize.xLarge
    
    // MARK: Sub Views
    
    private var navigationBar = CustomNavigationBar(title: "프로필 편집", backBtnMode: .push)
    
    private var imageView: UIView!
    
    private var profileImgEditBtn = CustomIconButton(
        iconImage: UIImage(systemName: "camera"),
        iconColor: .moneyTogether.grayScale.baseGray0,
        backgroundColor: .moneyTogether.grayScale.baseGray40,
        size: 40,
        cornerRadius: 20)
    
    private let nicknameSectionTitle = UILabel.make(
        text: "닉네임",
        font: .moneyTogetherFont(style: .b1),
        numberOfLines: 1
    )
    private var nicknameTextField = CustomTextField(placeholder: "닉네임을 입력하세요.")
    private var nicknameValidationLabel = UILabel.make(
        text: "* 최소 2자 ~ 최대 10자, 특수문자 불가능",
        textColor: .moneyTogether.label.normal,
        font: .moneyTogetherFont(style: .detail2),
        numberOfLines: 1
    )
    
    private var completeButton = CTAUIButton(activeState: .inactive,
                                     buttonStyle: .solid,
                                     labelText: "완료")
 
    // MARK: Init & ViewDidLoad
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
        setActions()
        setLayout()
        setBindings()
    }
}


// MARK: Setup
extension EditProfileViewController {
    
    /// sub views, ui components 세팅하는 함수
    private func setUI() {
        view.backgroundColor = UIColor.moneyTogether.background
        
        // profile image
        let rootView = ProfileImageView(size: profileImgSize, imageUrl: viewModel.orgData.imageUrl)
        let profileImgHostingVC = UIHostingController(rootView: rootView)
        self.imageView = profileImgHostingVC.view!.disableAutoresizingMask()
        
        // nickname field
        self.nicknameTextField.text = viewModel.orgData.nickname
        self.nicknameTextField.delegate = self
    }
    
    /// sub views, ui components에서 필요한 액션 세팅하는 함수
    private func setActions() {
        // navigation bar
        self.navigationBar.backAction = {
            self.viewModel.cancelProfileEdit()
        }
        
        // profile image edit button
        self.profileImgEditBtn.setAction({
            self.showProfileImageActionSheet()
        })
        
        // complete buton
        self.completeButton.action = {
            self.viewModel.completeProfileEdit(nickname: self.nicknameTextField.text ?? "")
        }
    }
    
    /// sub views를 추가하고, 레이아웃을 설정하는 함수
    private func setLayout() {
        
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

            imageView.widthAnchor.constraint(equalToConstant: profileImgSize),
            imageView.heightAnchor.constraint(equalToConstant: profileImgSize),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 48),
            
            profileImgEditBtn.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -8),
            profileImgEditBtn.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            
            nicknameSectionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            nicknameSectionTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.side),
            nicknameSectionTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 48),
            
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
            
            self.showErrorAlert(title: "프로필 수정에 실패했어요", message: "입력한 내용과 네트워크를 확인해주세요.")
        }
    }
}


// MARK: Error Alert
extension EditProfileViewController {
    /// 프로필 수정 시 에러 발생했을 경우, 에러 Alert 띄우기
    private func showErrorAlert(title: String = "프로필 수정에 실패했어요", message: String = "입력한 내용과 네트워크를 확인해주세요.") {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(title: "확인", style: .default, handler: nil)
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: Update Profile Image
extension EditProfileViewController: PHPickerViewControllerDelegate {
    
    /// 프로필 이미지 수정 버튼 클릭 시, action sheet 띄우기
    func showProfileImageActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let imageInAlbum = UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: { _ in
            self.showPhotoPickerView()
        })
        
        let defaultImage = UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: { _ in
            self.viewModel.profileImageUpdateState = .resetToDefault
            self.updateProfileImageToDefault()
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(imageInAlbum)
        actionSheet.addAction(defaultImage)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    /// 포토 피커 띄우기
    private func showPhotoPickerView() {
        Task {
            if await PhotoManager.canAccessPhotoLibrary(from: self) {
                
                let picker = PhotoManager.createPhotoPickerView()
                picker.delegate = self
                self.present(picker, animated: true)
                
            } else {
                PhotoManager.handlePhotoLibraryPermissionDenied(from: self)
            }
        }
    }
    
    /// 포토 피커에서 이미지 선택 종료 시 호출
    final func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
        
        // 선택된 이미지가 없는 경우
        guard let imageResult = results.first else {
            return
        }
        
        let provider = imageResult.itemProvider
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { object, error in
                
                guard let uiImage = object as? UIImage,
                      let imageData = uiImage.jpegData(compressionQuality: 0.8) else {
                    if let error = error {
                        print(#fileID, #function, #line, "🔴 ERROR: \(error.localizedDescription)")
                    }
                    print(#fileID, #function, #line, "🔴 ERROR")
                    return
                }
                
                // 선택한 이미지를 정상적으로 로드했을 경우, 프로필 이미지 업데이트
                DispatchQueue.main.async {
                    self.viewModel.profileImageUpdateState = .updated(imageData)
                    self.updateProfileImage(fromAlbum: uiImage)
                }
                    
            }
        } else {
            print(#fileID, #function, #line, "🔴 ERROR: cannot load image object")
        }
    }
    
    /// 프로필 이미지 기본 이미지로 업데이트
    private func updateProfileImageToDefault() {
        // 기존 image view 삭제
        imageView.removeFromSuperview()

        // 새로운 ProfileImageView 생성
        let rootView = ProfileImageView(size: ProfileImgSize.xLarge, imageUrl: nil)
        let profileImgHostingVC = UIHostingController(rootView: rootView)
        self.imageView = profileImgHostingVC.view.disableAutoresizingMask()
        
        // 레이아웃 재설정
        self.setLayout()
    }
    
    /// 프로필 이미지 앨범에서 선택한 이미지로 업데이트
    private func updateProfileImage(fromAlbum image: UIImage?) {
        // 기존 image view 삭제
        imageView.removeFromSuperview()

        // 새로운 ProfileImageView 생성
        let uiImageView = UIImageView(image: image).disableAutoresizingMask()
        uiImageView.contentMode = .scaleAspectFill
        uiImageView.layer.masksToBounds = false
        uiImageView.layer.cornerRadius = self.profileImgSize / 2
        uiImageView.clipsToBounds = true
        
        self.imageView = uiImageView
        
        // 레이아웃 재설정
        self.setLayout()
    }
}


// MARK: Text Field
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
    EditProfileViewController(
        viewModel: EditProfileViewModel(orgData: UserProfile.createDummyData())
    )
}

#endif
