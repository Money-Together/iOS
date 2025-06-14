//
//  EditWalletProfileViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 6/2/25.
//

import Foundation
import UIKit

/// 지갑 프로필 편집 뷰
class EditWalletProfileViewController: UIViewController {
    var viewModel: WalletViewModel
    
    // MARK: Sub Views
    
    /// 화면 전체 스크롤 뷰
    private var scrollView: UIScrollView!
    
    /// 스크롤 뷰 내부 콘텐츠 뷰
    private var scrollContentsView: UIStackView!
    
    /// 네비게이션 바
    private var navigationBar: CustomNavigationBar!
    
    /// 지갑 이름 입력 필드
    private var nameTextField: CustomTextField!
    
    /// 지갑 한줄 소개 입력 필드
    private var bioTextField: CustomTextField!
    
    /// 저금통 사용 여부 토글 스위치
    private var cashBoxToggle: UISwitch!
    
    /// 저금통 사용 시 필요한 섹션
    /// 저금통 사용여부 토글 on/off 에 따라 보이거나 사라짐
    /// 저금통 금액, 정보 데이터 포함
    private var cashBoxSection: UIStackView!
    
    /// 저금통 금액 입력 필드
    private var cashBoxAmountTextField: CustomTextField!
    
    /// 저금통 정보 입력 필드
    private var cashBoxBioTextField: CustomTextField!
    
    /// 완료 버튼
    private var completeButton: CTAUIButton!
    
    
    // MARK: Init & Set up
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        setUI()
        setLayout()
        setUIWithData(with: self.viewModel.walletData)
    }
    
    /// 뷰모델 데이터 바인딩 처리
    private func setBindings() {
        // 완료 버튼 활성화 여부에 따른 버튼 UI 변경
        self.viewModel.isCompleteBtnEnable.bind({ [weak self] isEnable in
            guard let self = self else { return }
            self.completeButton.setButtonEnabled(isEnable)
        })
        
        self.viewModel.isErrorAlertVisible.bind({ [weak self] isVisible in
            guard let self = self else { return }
            self.showErrorAlert(title: "지갑 프로필 수정을 실패했어요", message: "입력한 내용과 네트워크를 확인해주세요.")
        })
    }
    
    /// 서브뷰 UI 세팅
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        self.hideKeyboardWhenTappedAround()
        
        // 스크롤 뷰
        self.scrollView = UIScrollView().disableAutoresizingMask()
        
        // 스크롤 뷰 내부 컨텐츠 뷰
        self.scrollContentsView = UIStackView.makeVStack(
            distribution: .fill,
            alignment: .fill,
            spacing: 48
        )
        scrollContentsView.isLayoutMarginsRelativeArrangement = true
        scrollContentsView.layoutMargins = UIEdgeInsets(top: 48, left: Layout.side, bottom: 48, right: Layout.side)
        
        // 네비게이션 바
        self.navigationBar = CustomNavigationBar(
            title: "지갑 편집",
            backBtnMode: .push,
            backAction: {
                self.viewModel.cancelWalletProfileEditing()
            }
        )
        
        // 지갑 이름 입력 필드
        self.nameTextField = CustomTextField(placeholder: "지갑 이름을 입력하세요. (최대 15자)")
        self.nameTextField.delegate = self
        
        // 지갑 한줄 소개 입력 필드
        self.bioTextField = CustomTextField(placeholder: "지갑에 대한 짧은 소개글을 작성하세요. (최대 50자)")
        self.bioTextField.delegate = self
        
        // 저금통 사용 여부 토글 스위치
        self.cashBoxToggle = UISwitch(frame: .zero, primaryAction: UIAction(handler: { action in
            let toggle = action.sender as? UISwitch
            self.cashboxToggleChanged(toggle?.isOn ?? false)
        }))
        cashBoxToggle.translatesAutoresizingMaskIntoConstraints = false
        cashBoxToggle.onTintColor = .moneyTogether.grayScale.baseGray100
        
        // 저금통 사용 시 필요한 섹션
        self.cashBoxSection = UIStackView.makeVStack(
            distribution: .fill,
            alignment: .fill,
            spacing: 48
        )
        
        // 저금통 금액 입력 필드
        self.cashBoxAmountTextField = CustomTextField(placeholder: "금액을 입력하세요.")
        self.cashBoxAmountTextField.delegate = self
        
        // 저금통 정보 입력 필드
        self.cashBoxBioTextField = CustomTextField(placeholder: "저금통 은행 등 간단한 정보를 작성하세요. (최대 20자)")
        self.cashBoxBioTextField.delegate = self
        
        // 완료 버튼
        self.completeButton = CTAUIButton(
            activeState: .inactive,
            buttonStyle: .solid,
            labelText: "완료",
            action: {
                print(#fileID, #function, #line, "complete button tapped")
                self.viewModel.completeWalletProfileEditing()
            }
        )
        
    }
    
    /// 서브뷰 레이아웃 세팅
    private func setLayout() {
        
        let walletNameSection = createSectionView(title: "지갑 이름 *", content: [self.nameTextField])
        
        let walletBioSection = createSectionView(title: "한줄 소개", content: [self.bioTextField])
        
        let cashBoxToggleSection: UIView = {
            let titleLabel = createSectionTitleLabel(title: "저금통")
            
            let descriptionLabel = UILabel.make(
                text: "모든 멤버들과 함께 사용할 수 있는 저금통이에요!",
                textColor: .moneyTogether.label.assistive,
                font: .moneyTogetherFont(style: .detail2),
                numberOfLines: 0)
            
            let view = UIView().disableAutoresizingMask()
            
            view.addSubview(titleLabel)
            view.addSubview(descriptionLabel)
            view.addSubview(cashBoxToggle)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
                
                descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                cashBoxToggle.leadingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor, constant: 12),
                cashBoxToggle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                cashBoxToggle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            return view
        }()
        
        let cashboxAmountDescription = UILabel.make(
            text: "통화는 따로 설정할 필요 없어요. 기본 통화로 자동 적용돼요.",
            textColor: .moneyTogether.label.assistive,
            font: .moneyTogetherFont(style: .detail2)
        )
        let cashboxAmountSection = createSectionView(title: "저금통 잔액 *", content: [self.cashBoxAmountTextField, cashboxAmountDescription])
        
        let cashboxBioSection = createSectionView(title: "저금통 정보", content: [self.cashBoxBioTextField])
        
        let spacingView: UIView = {
            let view = UIView().disableAutoresizingMask()
            
            view.heightAnchor.constraint(equalToConstant: 160).isActive = true
            view.backgroundColor = .clear
            
            return view
        }()
        
        // 저금통 섹션 서브뷰 추가
        cashBoxSection.addArrangedSubViews([
            cashboxAmountSection, cashboxBioSection
        ])
        
        // 스크롤뷰 내부 컨텐츠뷰 서브뷰 추가
        scrollContentsView.addArrangedSubViews([
            walletNameSection, walletBioSection, cashBoxToggleSection, cashBoxSection, spacingView, completeButton
        ])
        
        // 메인 뷰 세팅
        self.view.addSubview(navigationBar)
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollContentsView)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            scrollContentsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentsView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentsView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        // 저금통 사용여부에 따라 섹션 hidden 초기 세팅
        self.cashBoxSection.isHidden = !self.cashBoxToggle.isOn
    }
    
    /// 받아온 데이터로 뷰 세팅
    private func setUIWithData(with data: Wallet?) {
        guard let walletData = data else { return }
        
        self.nameTextField.text = walletData.name
        self.bioTextField.text = walletData.bio
        self.cashBoxToggle.setOn(walletData.hasCashBox, animated: false)
        self.cashBoxSection.isHidden = !walletData.hasCashBox
        
        if let cashBoxData = walletData.cashBox {
            self.cashBoxAmountTextField.text = cashBoxData.amount
            self.cashBoxBioTextField.text = cashBoxData.bio ?? ""
        }
        
    }
    
    /// 저금통 사용 여부 토글이 바뀔 때 호출
    /// - Parameter isOn: 토글 스위치 on / off 바뀐 값
    private func cashboxToggleChanged(_ isOn: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.cashBoxSection.isHidden = !isOn
            self.scrollContentsView.layoutIfNeeded()
        }
        
        // 저금통 사용여부 데이터 편집 상태 업데이트
        self.viewModel.updateHasCashBoxEditState(isOn)
        
        // 저금통 사용 on/off 에 따라, 저금통 사용 시에만 필요한 데이터 세팅
        for textField in [cashBoxAmountTextField, cashBoxBioTextField] {
            guard let textField = textField else { continue }
            
            // 저금통 사용 Off 시, 저금통을 사용할 때만 필요한 데이터 초기화
            if !isOn {
                textField.text = ""
            }
            
            // 저금통을 사용할 때만 필요한 데이터 편집 상태 업데이트
            switch textField {
            case cashBoxAmountTextField:
                self.viewModel.updateWalletProfileDataEditState(of: .cashboxAmount, value: "")
            case cashBoxBioTextField:
                self.viewModel.updateWalletProfileDataEditState(of: .cashboxBio, value: "")
            default:
                continue
            }
        }
    }
}

// MARK: View Creators
extension EditWalletProfileViewController {
    
    /// [섹션 타이틀 + 컨텐츠 뷰] 레이아웃으로 섹션 생성하는 함수
    /// - Parameters:
    ///   - title: 타이틀
    ///   - content: 컨텐츠뷰
    /// - Returns: [ 타이틀 + 컨텐츠 뷰 ] 레이아웃으로 구성된 section 뷰
    private func createSectionView(title: String, content: [UIView]) -> UIView {
        let titleLabel = createSectionTitleLabel(title: title)
        
        let view = UIStackView.makeVStack(
                distribution: .fill,
                alignment: .fill,
                spacing: 12,
                subViews: [titleLabel]
        )
        
        view.addArrangedSubViews(content)
        
        return view
    }
    
    
    private func createSectionTitleLabel(title: String) -> UILabel {
        let titleLabel = UILabel.make(
            text: title,
            font: .moneyTogetherFont(style: .b2),
            numberOfLines: 1
        )
        
        return titleLabel
    }
}

extension EditWalletProfileViewController: UITextFieldDelegate {
    
    /// 텍스트필드 입력값이 변할 때 호출되는 함수
    /// - 저금통 금액 입력 필드인 경우, 입력값이 유효한 문자(숫자, 소수점)인지 확인 후 적용 여부 판단
    /// - Parameters:
    ///   - textField: 이벤트가 발생한 텍스트필드
    ///   - range: 바뀐 텍스트 위치 & 길이
    ///   - string: 바뀐 텍스트
    /// - Returns: true일 경우 바뀐 텍스트를 적용, false일 경우 미적용
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if [nameTextField, bioTextField, cashBoxBioTextField].contains(textField) {
            return true
        }
        
        guard textField == self.cashBoxAmountTextField else {
           return false
        }
        
        return string.isDecimalStyle()
    }
    
    /// 텍스트필드 입력값이 바뀐 이후 호출되는 함수
    /// - 유효한 입력 길이를 넘겼을 경우, 유효한 범위 내 문자열로 변경
    /// - 저금통 금액 입력필드인 경우, decimal 형식 적용된 문자열로 변경
    /// - Parameter textField: 이벤트가 발생한 텍스트필드
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == self.cashBoxAmountTextField {
            self.handleAmountTextFieldChange(textField, isEndEditing: false)
            return
        }
        
        self.handleTextFieldChange(textField)
    }
    
    /// 텍스트필드 편집이 완료되었을 때 호출되는 함수
    /// - 유효한 입력 길이를 넘겼을 경우, 유효한 범위 내 문자열로 변경
    /// - 저금통 금액 입력필드인 경우, decimal 형식 적용된 문자열로 변경
    /// - Parameter textField: 이벤트가 발생한 텍스트필드
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.cashBoxAmountTextField {
            self.handleAmountTextFieldChange(textField, isEndEditing: true)
            return
        }
        
        self.handleTextFieldChange(textField)
    }
    
    /// 텍스트필드 입력값이 변경되었을 때 이벤트 처리
    /// - Parameter textField: 이벤트가 발생한 텍스트필드
    private func handleTextFieldChange(_ textField: UITextField) {
        guard [nameTextField, bioTextField, cashBoxBioTextField].contains(textField) else {
            return
        }
        
        let textFieldType: WalletProfileInputType
        switch textField {
        case self.nameTextField:            textFieldType = .name
        case self.bioTextField:             textFieldType = .bio
        case self.cashBoxBioTextField:      textFieldType = .cashboxBio
        default: return
        }
        
        var input = textField.text ?? ""
        if input.count > textFieldType.maxLength {
            input = String(input.prefix(textFieldType.maxLength))
            textField.text = input
        }
        
        self.viewModel.updateWalletProfileDataEditState(of: textFieldType, value: input)
    }
    
    /// 금액 텍스트필드 입력값이 변경되었을 때 이벤트 처리
    /// - Parameters:
    ///   - textField: 이벤트가 발생한 텍스트필드
    ///   - isEndEditing: 입력 완료 여부, 입력 도중일 경우 소수점 아래 최대한 보존
    private func handleAmountTextFieldChange(_ textField: UITextField, isEndEditing: Bool) {
        let textFieldType: WalletProfileInputType = .cashboxAmount
        let input = textField.text ?? ""
        
        // 입력값을 decimal 스타일로 변환
        // 입력 도중일 경우 소수점 아래 최대한 보존
        let numberString = input.replacingOccurrences(of: ",", with: "")
        var decimalString = isEndEditing ? numberString.decimalStyle() : numberString.decimalWithPoint()
        
        // 입력값이 유효한 길이를 넘었을 경우 유효한 범위 내 문자열로 변경
        if decimalString.count > textFieldType.maxLength {
            decimalString = String(input.prefix(textFieldType.maxLength))
        }
        
        // 텍스트필드 UI 업데이트
        textField.text = decimalString
        self.viewModel.updateWalletProfileDataEditState(of: .cashboxAmount, value: decimalString)
    }
}

#if DEBUG

import SwiftUI

// 1. UIViewController 래퍼 정의
struct EditWalletProfileViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewModel = WalletViewModel()
        viewModel.fetchWalletData()
        
        return EditWalletProfileViewController(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // 업데이트 로직이 필요 없다면 비워두세요
    }
}


#Preview {
    let viewModel = WalletViewModel()
    viewModel.fetchWalletData()
    return EditWalletProfileViewController(viewModel: viewModel)
}

#endif
