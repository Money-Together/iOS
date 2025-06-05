//
//  EditUserAssetViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/17/25.
//

import Foundation
import UIKit

class EditUserAssetViewController: UIViewController {
    
    var viewModel: EditUserAssetViewModel
    
    // MARK: Sub Views
    
    private var contentsStackView = UIStackView.makeVStack(
        distribution: .fill,
        alignment: .fill,
        spacing: 24,
        subViews: [])
    
    private var navigationBar = CustomNavigationBar(title: "프로필 편집", backBtnMode: .push)
    
    private var assetNameTextField = CustomTextField(placeholder: "자산 이름을 입력하세요.")
    
    private var assetAmountInputView: CurrencyAmountInputView!
    
    private var assetBioTextField = CustomTextField(placeholder: "타입, 은행명 등 간단한 정보를 작성하세요. (최대 20자)")
    
    private var completeButton = CTAUIButton(
        activeState: .inactive,
        buttonStyle: .solid,
        labelText: "완료"
    )

    // MARK: Init & ViewDidLoad
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: EditUserAssetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBindings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setUI()
        setLayout()
    }
}

// MARK: Setup
extension EditUserAssetViewController {

    /// sub views, ui components 세팅하는 함수
    private func setUI() {
        view.backgroundColor = UIColor.moneyTogether.background
        
        // navigation bar
        self.navigationBar.backAction = {
            self.viewModel.cancelUserAssetEdit()
        }
        
        // Asset amount input view
        assetAmountInputView = CurrencyAmountInputView(
            showCurrencyPickerAction: {
                let pickerViewController = CurrencyTypePickerViewController(viewModel: self.viewModel)
                pickerViewController.sheetPresentationController?.detents = [.medium()]
                
                self.present(pickerViewController, animated: true)
            }
        )
        self.setUIWithData(with: self.viewModel.orgData.value)
        
        // TextFields
        self.assetNameTextField.delegate = self
        self.assetBioTextField.delegate = self
        
        // complete btn
        self.completeButton.setAction({
            self.viewModel.completeUserAssetEdit()
        })
    }

    /// sub views를 추가하고, 레이아웃을 설정하는 함수
    private func setLayout() {

        let assetNameSectiontitle = UILabel.make(
            text: "자산 이름",
            font: .moneyTogetherFont(style: .b1),
            numberOfLines: 1
        )
        
        let assetAmountSectiontitle = UILabel.make(
            text: "자산 잔액",
            font: .moneyTogetherFont(style: .b1),
            numberOfLines: 1
        )
        
        let assetBioSectiontitle = UILabel.make(
            text: "자산 정보",
            font: .moneyTogetherFont(style: .b1),
            numberOfLines: 1
        )
        
        view.addSubview(navigationBar)
        view.addSubview(contentsStackView)
        view.addSubview(completeButton)
        
        contentsStackView.addArrangedSubview(assetNameSectiontitle)
        contentsStackView.addArrangedSubview(assetNameTextField)
        contentsStackView.addArrangedSubview(assetAmountSectiontitle)
        contentsStackView.addArrangedSubview(assetAmountInputView)
        contentsStackView.addArrangedSubview(assetBioSectiontitle)
        contentsStackView.addArrangedSubview(assetBioTextField)

        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            
            contentsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.side),
            contentsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentsStackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 48),
            
            completeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.side),
            completeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    /// 받아온 데이터로 뷰 세팅
    private func setUIWithData(with data: UserAsset?) {
        self.assetNameTextField.text = data?.title ?? ""
        self.assetBioTextField.text = data?.bio ?? ""
        self.assetAmountInputView.updatePickedCurrencyLabel(currencyType: self.viewModel.currencyType.value)
        self.assetAmountInputView.updateAmountText(with: data?.amount ?? "")
    }
    
    /// 뷰모델과 데이터 바인딩 설정하는 함수
    private func setBindings() {
        viewModel.orgData.bind({ [weak self] data in
            guard let self = self else { return }
            self.setUIWithData(with: data)
        })
        
        viewModel.isCompleteBtnEnable.bind{ [weak self] isEnable in
            guard let self = self else { return }
            self.completeButton.setButtonEnabled(isEnable)
        }
        
        viewModel.currencyType.bind{ [weak self] newType in
            guard let self = self else { return }
            self.assetAmountInputView.updatePickedCurrencyLabel(currencyType: newType)
        }
        
        assetAmountInputView.currencyTypeBinding = { [weak self] currencyType in
            guard let self = self else { return }
            self.viewModel.updateAssetCurrencyType(newValue: currencyType)
        }
        
        assetAmountInputView.assetAmountBinding = { [weak self] amountString in
            guard let self = self else { return }
            self.viewModel.updateAssetAmount(newValue: amountString)
        }
    }
}


// MARK: Text Field
extension EditUserAssetViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard [assetNameTextField, assetBioTextField].contains(textField),
              let input = textField.text else {
            return
        }
        
        switch textField {
        case self.assetNameTextField:
            self.viewModel.updateAssetName(newValue: input)
        case self.assetBioTextField:
            self.viewModel.updateAssetBio(newValue: input)
        default:
            print(#fileID, #function, #line, "sth end editing")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard [assetNameTextField, assetBioTextField].contains(textField),
              let input = textField.text else {
            return
        }

        switch textField {
        case self.assetNameTextField:
            self.viewModel.updateAssetName(newValue: input)
        case self.assetBioTextField:
            self.viewModel.updateAssetBio(newValue: input)
        default:
            print(#fileID, #function, #line, "sth end editing")
        }
    }
    
}


#if DEBUG

import SwiftUI

#Preview {
    EditUserAssetViewController(viewModel: EditUserAssetViewModel())
}

#endif
