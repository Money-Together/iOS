//
//  WalletSettingViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 5/31/25.
//

import UIKit
import Foundation

class WalletSettingViewController: UIViewController {
    
    var viewModel: WalletViewModel
    
    // MARK: Sub Views
    
    /// 네비게이션 바
    private var navigationBar: CustomNavigationBar!
    
    /// 지갑 프로필 편집 버튼
    private var walletProfileEditBtn: CustomIconButton!
    
    /// 지갑 프로필 뷰
    private var walletProfileView: UIView!
    
    /// 지갑 세부 설정 리스트 스택
    private var settingListStackView: UIStackView!
    
    /// 월 시작일 설정 Row
    private var startDaySettingRow: UIView!
    
    /// 선택된 월 시작일 + 시작일 선택 페이지 이동 암시를 위한 아이콘 ( > )
    private var startDayRowTrailingView: UIView!
    
    /// 기본 통화 설정 Row
    private var baseCurrencySettingRow: UIView!
    
    /// 선택된 기본 통화 + 통화 선택 페이지 이동 암시를 위한 아이콘 ( > )
    private var baseCurrencyRowTrailingView: UIView!
    
    /// 카테고리 설정 Row
    private var categorySettingRow: UIView!
    
    /// 카테고리 리스트 페이지 이동 암시를 위한 아이콘 ( > )
    private var categoryRowTrailingView: UIView!
    
    /// 알림 설정 Row
    private var notificationSettingRow: UIView!
    
    /// 알림 설정 토글 스위치
    private var notificationRowTrailingView: UISwitch!
    
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
        setUI()
        setLayout()
    }
    
    /// view & sub views UI 설정
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        
        // 네비게이션 바
        self.navigationBar = CustomNavigationBar(
            title: "지갑 설정",
            backBtnMode: .push,
            backAction: {
                self.viewModel.onBackTapped?(.walletSetting)
            }
        )
        
        // 지갑 프로필 편집 버튼
        self.walletProfileEditBtn = CustomIconButton(
            iconImage: UIImage(named: "more_horiz"),
            action: {
                print(#fileID, #function, #line, "navigate to wallet profile edit page")
                self.viewModel.walletEditBtnTapped?()
            })
        
        // 지갑 프로필 뷰
        self.walletProfileView = {
            let rootView = WalletProfileSettingsView(viewModel: self.viewModel)
            let hostingVC = UIHostingController(rootView: rootView)
            let uiView = hostingVC.view.disableAutoresizingMask()
            
            uiView.backgroundColor = .clear
            
            return uiView
        }()
        
        // 지갑 세부 설정 리스트 스택
        self.settingListStackView = UIStackView.makeVStack(
            distribution: .fill,
            alignment: .fill,
            spacing: 4)
        self.settingListStackView.layer.cornerRadius = Radius.large
        self.settingListStackView.backgroundColor = .moneyTogether.background
        self.settingListStackView.addShadow(color: .moneyTogether.grayScale.baseGray30, offset: CGSize(width: 0, height: 5), opacity: 1, radius: 5)
        
        self.settingListStackView.isLayoutMarginsRelativeArrangement = true
        self.settingListStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: Layout.side, bottom: 12, trailing: Layout.side)
        
        // 월 시작일 Row
        self.startDayRowTrailingView = createRowTrailingView(contentText: "1일")
        self.startDaySettingRow = createSettingRow(title: "월 시작일", trailingView: self.startDayRowTrailingView, tabAction: {
            
            // 월 시작일 선택 모달 띄우기
            let hostingVC = UIHostingController(rootView: WalletStartDayPickerView(selectedDay: 1, onDone: { selectedDay in
                print(#fileID, #function, #line, "selected start day: \(selectedDay)")
            }))
            hostingVC.modalPresentationStyle = .formSheet
            if let sheet = hostingVC.sheetPresentationController {
                sheet.detents = [.customFraction(0.4)]
                sheet.largestUndimmedDetentIdentifier = .medium
            }
            self.present(hostingVC, animated: true)
        })
        
        // 기본 통화 Row
        self.baseCurrencyRowTrailingView = createRowTrailingView(contentText: "KRW")
        self.baseCurrencySettingRow = createSettingRow(title: "기본 통화", trailingView: self.baseCurrencyRowTrailingView, tabAction: {
            print(#fileID, #function, #line, "통화 리스트 페이지로 이동")
        })
        
        // 카테고리 Row
        self.categoryRowTrailingView = createRowTrailingView(contentText: "")
        self.categorySettingRow = createSettingRow(title: "카테고리", trailingView: self.categoryRowTrailingView, tabAction: {
            print(#fileID, #function, #line, "카테고리 리스트 페이지로 이동")
        })
        
        // 알림 Row
        self.notificationRowTrailingView = UISwitch(frame: .zero, primaryAction: UIAction(handler: { action in
            let toggle = action.sender as? UISwitch
            print(#fileID, #function, #line, "toggle isOn: \(toggle?.isOn)")
        }))
        notificationRowTrailingView.translatesAutoresizingMaskIntoConstraints = false
        notificationRowTrailingView.onTintColor = .moneyTogether.grayScale.baseGray100
        self.notificationSettingRow = createSettingRow(title: "알림", trailingView: self.notificationRowTrailingView)
        
    }
    
    /// sub views 레이아웃 설정
    private func setLayout() {
        
        settingListStackView.addArrangedSubViews([
            startDaySettingRow, baseCurrencySettingRow, categorySettingRow, notificationSettingRow
        ])
        
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(walletProfileView)
        self.view.addSubview(walletProfileEditBtn)
        self.view.addSubview(settingListStackView)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            walletProfileView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 8),
            walletProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            walletProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            walletProfileEditBtn.topAnchor.constraint(equalTo: walletProfileView.topAnchor, constant: 8),
            walletProfileEditBtn.trailingAnchor.constraint(equalTo: walletProfileView.trailingAnchor, constant: -8),

            settingListStackView.topAnchor.constraint(equalTo: walletProfileView.bottomAnchor, constant: 24),
            settingListStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            settingListStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
}

// MARK: View Creators
extension WalletSettingViewController {
    /// 세부 설정 row 생성 함수
    /// - Parameters:
    ///   - title: row 타이틀
    ///   - trailingView: row 오른쪽 (trailing)에 들어갈 뷰, Nil 일 경우 empty view가 임의로 들어감
    ///   - tabAction: Row 탭 했을 시, 실행되는 액션 클로져
    /// - Returns: 생성된 Row 뷰
    private func createSettingRow(title: String, trailingView: UIView?, tabAction: (() -> Void)? = nil) -> UIView {
        
        let view = UIView().disableAutoresizingMask()
        
        // set title label
        let titleLabel = createRowTitleLabel(title: title)
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // set trailing view
        if let contentTrailingView = trailingView {
            view.addSubview(contentTrailingView)
            
            NSLayoutConstraint.activate([
                contentTrailingView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
                contentTrailingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentTrailingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        } else {
            // if no trailing view
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        
        
        // set tab action
        if tabAction != nil {
            let btnforTab = UIButton(primaryAction: UIAction(handler: { _ in
                // print(#fileID, #function, #line, "row tab")
                tabAction?()
            })).disableAutoresizingMask()
            view.addSubview(btnforTab)
            NSLayoutConstraint.activate([
                btnforTab.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                btnforTab.topAnchor.constraint(equalTo: view.topAnchor),
                btnforTab.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                btnforTab.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        
        return view
    }
    
    /// 세부설정 Row trailing view 생성 함수
    /// [some content] [ > 아이콘 이미지] 형태로 구성됨
    /// - some content: 설정값을 보여주기 위한 텍스트 라벨
    /// - > 아이콘 이미지: 페이지 이동 또는 모달 띄우기가 가능함을 암시하기 위한 이미지
    /// - Parameter contentText: [ some content ]에 들어갈 텍스트
    /// - Returns: 생성된 trailing view
    private func createRowTrailingView(contentText: String) -> UIView {
        let view = UIView().disableAutoresizingMask()
        
        // sub views
        let textLabel = createRowContentLabel(text: contentText)
        let iconImg = UIImageView(image: UIImage(named: "chevron_right"))
        iconImg.iconStyle(iconColor: .moneyTogether.label.assistive, size: 12)
        
        view.addSubview(textLabel)
        view.addSubview(iconImg)
        
        // set layout
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iconImg.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 8),
            iconImg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImg.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImg.topAnchor.constraint(equalTo: view.topAnchor)
        ])


        return view
    }
    
    /// 세부설정 Row 타이틀 라벨 생성 함수
    private func createRowTitleLabel(title: String) -> UILabel {
        let titleLabel = UILabel.make(
            text: title,
            font: .moneyTogetherFont(style: .b2),
            numberOfLines: 1
        )
        
        return titleLabel
    }
    
    /// trailing view의 설정값을 보여주기 위한 content label을 생성하는 함수
    private func createRowContentLabel(text: String) -> UILabel {
        let label = UILabel.make(
            text: text,
            textColor: .moneyTogether.label.alternative,
            font: .moneyTogetherFont(style: .b1),
            numberOfLines: 1
        )
        
        return label
    }
}

#if DEBUG

import SwiftUI

#Preview {
    let viewModel = WalletViewModel()
    viewModel.fetchWalletData()
    viewModel.fetchMembers()
    
    return WalletSettingViewController(viewModel: viewModel)
}

#endif
