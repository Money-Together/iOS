//
//  CurrencyAmountInputView.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/19/25.
//

import Foundation
import UIKit

class CurrencyAmountInputView: UIView {
    
    private var showCurrencyPickerAction: (() -> Void)?
    
    var assetAmountBinding: ((String) -> Void)?
    
    var currencyTypeBinding: ((CurrencyType) -> Void)?
    
    
    // MARK: UI Components
    private var pickedCurrencyLabel: UILabel!
    
    private var currencyPickerBtn: UIView!
    
    private var amountTextField: UITextField!
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(defaultCurrencyType: CurrencyType = .krw,
         defaultAmountString: String = "",
        showCurrencyPickerAction: (() -> Void)?) {

        self.showCurrencyPickerAction = showCurrencyPickerAction
        
        super.init(frame: .zero)
        
        self.setUI(currencyType: defaultCurrencyType, amountString: defaultAmountString)
        self.setLayout()
        self.setAction()
    }
    
    /// sub views, ui components 세팅하는 함수
    private func setUI(currencyType: CurrencyType,
                       amountString: String) {
        
        // 금액 입력 텍스트필드 세팅
        amountTextField = CustomTextField(placeholder: "금액을 입력하세요.")
        amountTextField.keyboardType = .decimalPad
        amountTextField.delegate = self
        self.updateAmountText(with: amountString)
        
        // 통화 선택 버튼 내부 라벨 세팅
        pickedCurrencyLabel = UILabel.make(
            text: "",
            font: .moneyTogetherFont(style: .detail1),
            numberOfLines: 1
        )
        pickedCurrencyLabel.textAlignment = .center
        self.updatePickedCurrencyLabel(currencyType: currencyType)
        
        // 통화 선택 버튼 세팅
        currencyPickerBtn = {
            let view = UIView().disableAutoresizingMask()
            
            view.backgroundColor = .clear
            view.layer.cornerRadius = Radius.small
            view.layer.borderColor = UIColor.moneyTogether.line.normal?.cgColor
            view.layer.borderWidth = 1
            
            // [아래 화살표 이미지]
            let iconImageView: UIImageView = {
                let img = UIImage(systemName: "chevron.down")
                
                let imgView = UIImageView(image: img).disableAutoresizingMask()
                imgView.image = img?.withRenderingMode(.alwaysTemplate)
                imgView.contentMode = .scaleAspectFit
                imgView.backgroundColor = .clear
                imgView.tintColor = .moneyTogether.label.normal
                
                NSLayoutConstraint.activate([
                    imgView.widthAnchor.constraint(equalToConstant: 14)
                ])
                
                return imgView
            }()
            
            // [ 통화 ISO Code(통화 심볼) [아래 화살표 이미지] ] 가로 스택
            let currencyTypePickerHStk = UIStackView.makeHStack(distribution: .fill, alignment: .fill, spacing: 4, subViews: [
                pickedCurrencyLabel,
                iconImageView
            ])
            
            view.addSubview(currencyTypePickerHStk)
            NSLayoutConstraint.activate([
                currencyTypePickerHStk.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                currencyTypePickerHStk.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                currencyTypePickerHStk.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
                currencyTypePickerHStk.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor)
            ])
            
            return view
        }()
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// sub views를 추가하고, 레이아웃을 설정하는 함수
    private func setLayout() {
        self.addSubview(currencyPickerBtn)
        self.addSubview(amountTextField)
        
        NSLayoutConstraint.activate([
            currencyPickerBtn.widthAnchor.constraint(equalToConstant: 92),
            currencyPickerBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            currencyPickerBtn.trailingAnchor.constraint(equalTo: amountTextField.leadingAnchor, constant: -12),
            
            currencyPickerBtn.topAnchor.constraint(equalTo: amountTextField.topAnchor),
            currencyPickerBtn.bottomAnchor.constraint(equalTo: amountTextField.bottomAnchor),
            
            amountTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            amountTextField.topAnchor.constraint(equalTo: self.topAnchor),
            amountTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /// sub views, ui components에서 필요한 액션 세팅하는 함수
    private func setAction() {
        currencyPickerBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCurrencyTypePickerBtnTap)))
    }
    
    /// 통화 선택 뷰 클릭 시 핸들러
    @objc func handleCurrencyTypePickerBtnTap(_ target: UITapGestureRecognizer) {
        print(#fileID, #function, #line, "pick curreny type")
        self.showCurrencyPickerAction?()
    }
    
    /// 선택된 통화 라벨 업데이트
    /// - Parameter currencyType: 선택된 통화 타입
    func updatePickedCurrencyLabel(currencyType: CurrencyType) {
        self.pickedCurrencyLabel.text = currencyType.displayName
    }
    
    /// 금액 텍스트필드 입력값을 decimal 스타일로 업데이트
    /// - Parameter input: 금액 텍스트필드 입력값
    func updateAmountText(with input: String) {
        // 입력값 선택된 통화에 맞는 decimal 스타일로 변환
        let decimalString = input.replacingOccurrences(of: ",", with: "").decimalWithPoint()
        
        // 텍스트필드 UI 업데이트
        self.amountTextField.text = decimalString
        self.assetAmountBinding?(decimalString)
    }
}

// MARK: Amount Text Field
extension CurrencyAmountInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.amountTextField else {
           return false
        }
        
        // 입력 가능한 문자 = 숫자, 소수점
        var validCharacters = CharacterSet.decimalDigits
        validCharacters.insert(".")
        
        return string.rangeOfCharacter(from: validCharacters.inverted) == nil
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField == self.amountTextField,
              let amountString = textField.text else {
            return
        }
        
        // 입력값 변경 시마다 decimal 스타일로 업데이트
        self.updateAmountText(with: amountString)
    }
    
}
