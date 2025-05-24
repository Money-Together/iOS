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
        self.updateAmountText(amountString: amountString)
        
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
    
    @objc func handleCurrencyTypePickerBtnTap(_ target: UITapGestureRecognizer) {
        print(#fileID, #function, #line, "pick curreny type")
        self.showCurrencyPickerAction?()
    }
    
    func updatePickedCurrencyLabel(currencyType: CurrencyType) {
        self.pickedCurrencyLabel.text = currencyType.displayName
    }
    
    func updateAmountText(amountString: String) {
        // 입력값 선택된 통화에 맞는 decimal 스타일로 변환
        
        guard let number = Decimal(string: amountString) else {
            return
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
//        formatter.currencyCode = self.pickedCurrencyType.code
//        formatter.locale = self.pickedCurrencyType.locale
        
        guard var decimalString = formatter.string(for: number) else {
            return
        }
        
        // 통화 기호 제거
//        let currencySymbol = self.pickedCurrencyType.symbol
//        var decimalString = formattedStr.hasPrefix(currencySymbol)
//        ? String(formattedStr.dropFirst(currencySymbol.count))
//        : formattedStr
        
        
        // 소수점 처리를 위해 .(dot)을 입력받은 경우 처리
        
        // 소수점(dot) 기준 split
        let components = amountString.split(separator: ".", omittingEmptySubsequences: false)
        
        // 소수점 아래 길이
        let fractionalLength = components.count == 2 ? components[1].count : 0
        
        // 소수점 아래 0으로 구성되어 있는지 여부
        let endsWithZero = components.count == 2 && components[1].allSatisfy { $0 == "0" }
        
        // 소수점 .(dot)이 1개 있고, 소수점 이하 숫자 개수가 max 이하 일 때
        // 소수점 아래 입력 살리기
        if components.count == 2
            && formatter.maximumFractionDigits > 0 {
            
            // 소수점 아래 입력을 위해 .(dot)을 입력한 상태
            // ex) "22." -> .(dot) 유지
            if fractionalLength == 0 {
                decimalString += "."
            }
            
            // 소수점 아래에 0을 입력한 상태
            // ex) "22.0", "22.00" -> 0 유지
            else if endsWithZero {
                decimalString += "." + String(repeating: "0", count: min(fractionalLength, formatter.maximumFractionDigits))
            }
        }
        
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
        
        var validCharacters = CharacterSet.decimalDigits
        validCharacters.insert(".")
        
        return string.rangeOfCharacter(from: validCharacters.inverted) == nil
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField == self.amountTextField,
              let amountString = textField.text?.replacingOccurrences(of: ",", with: "") else {
            return
        }
        
        self.updateAmountText(amountString: amountString)
    }
    
}
