//
//  MyPageViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 4/22/25.
//

import Foundation
import UIKit


/// 마이페이지 뷰
class MyPageViewController: UIViewController {
    
    var viewModel: MyPageViewModel
    
    let userProfileView = UserProfileView()
    
    
    // MARK: Init & Setup
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bindViewModel()
        viewModel.fetchUserProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    /// Sub Views, UI Components 세팅
    private func setUI() {
        userProfileView.updateUI(newData: self.viewModel.profile)
        view.addSubview(userProfileView)
        
        view.backgroundColor = UIColor.moneyTogether.background
    }
    
    /// components로 레이아웃 구성
    private func setLayout() {
        NSLayoutConstraint.activate([
            userProfileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userProfileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.side),
            userProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }
    
    /// 바인딩 처리
    private func bindViewModel() {
        viewModel.onProfileUpdated = { [weak self] in
            guard let self = self else { return }
            self.userProfileView.updateUI(newData: self.viewModel.profile)
        }
    }
}

/*
 
import SwiftUI
 
struct MyPageView: View {
    var spacing: CGFloat = 32
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
//                UserProfileView()
//                    .padding(.bottom, spacing)
                
                HStack {
                    Text("내 자산")
                        .moneyTogetherFont(style: .h4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Rectangle()
                        .frame(width: 40, height: 40)
                }.padding(.bottom, 12)
                
                VStack {

                }
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(Color.moneyTogether.grayScale.baseGray20)
                .padding(.bottom, spacing)
                
                VStack {
                }
                .frame(maxWidth: .infinity, minHeight: 500)
                .background(Color.moneyTogether.grayScale.baseGray20)
                
            }
            .padding(.horizontal, Layout.side)
            .padding(.vertical, 50)
        }
    }
}
*/

#if DEBUG

import SwiftUI

#Preview {
    MyPageViewController(viewModel: MyPageViewModel())
}

#endif
