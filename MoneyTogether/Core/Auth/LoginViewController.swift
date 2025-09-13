//
//  LoginViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/20/25.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import Combine


/// 로그인 뷰
class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: sub views
    
    /// 애플로그인 버튼
    private var appleLoginButton: ASAuthorizationAppleIDButton!
    
    /// 구글 로그인 버튼
    private var googleLoginButton: GoogleLoginButton!
    
    // MARK: Init & Setup
    
    init(viewModel: LoginViewModel) {
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
        setBindings()
    }
    
    private func setBindings() {
        // 로그인 버튼 활성화 여부에 따라 애플 로그인 버튼 세팅
        viewModel.isLoginButtonEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: appleLoginButton)
            .store(in: &cancellables)

        // 로그인 버튼 활성화 여부에 따라 구글 로그인 버튼 세팅
        viewModel.isLoginButtonEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: googleLoginButton)
            .store(in: &cancellables)
        
        // 로그인 실패 시
        // 로그 출력 및 에러 alert 표시
        viewModel.onLoginFailure = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showErrorAlert(title: "로그인을 실패하였습니다.")
            }
            print(#fileID, #function, #line, "❌ Error: \(error.localizedDescription)")
        }
    }
    
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        
        setupAppleLoginButton()
        setupGoogleLoginButton()
        
        view.addSubview(googleLoginButton)
        view.addSubview(appleLoginButton)
        
    }
    
    private func setLayout() {
        
        let titleLabel = UILabel.make(
            text: "Money Together",
            font: .moneyTogetherFont(style: .h1)
        )
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 44),
            
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 44),
            
            googleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            appleLoginButton.bottomAnchor.constraint(equalTo: googleLoginButton.topAnchor, constant: -16),
        ])

    }
}

extension LoginViewController {
    /// 구글 로그인 버튼 세팅
    private func setupGoogleLoginButton() {
        self.googleLoginButton = GoogleLoginButton(mode: .white)
        self.googleLoginButton.addAction(UIAction(handler: { _ in
            // print(#fileID, #function, #line, "google login")
            self.didTapGoogleLoginButton()
        }), for: .touchUpInside)
    }
    
    /// 구글 로그인 버튼 클릭 핸들링
    /// 구글 소셜로그인 완료 후, 파이어베이스 & 서버 로그인 호출
    private func didTapGoogleLoginButton() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.viewModel.onLoginFailure?(AuthError.socialLoginFailed(description: ""))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            
            do {
                if let error = error {
                    throw AuthError.socialLoginFailed(description: String(describing: error.localizedDescription))
                }
                
                guard let user = signInResult?.user else {
                    throw AuthError.socialLoginFailed(description: "")
                }
                
                guard let googleIdToken = user.idToken?.tokenString else {
                    throw AuthError.socialLoginFailed(description: "invalid idToken")
                }
                
                let accessToken: String = user.accessToken.tokenString
                
                // 파이어베이스, 서버 로그인
                self.viewModel.login(
                    with: .google(
                        idToken: googleIdToken,
                        accessToken: accessToken
                    )
                )
            } catch {
                self.viewModel.onLoginFailure?(error)
            }
        }
        
    }
}

extension LoginViewController {
    private func setupAppleLoginButton() {
        self.appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        appleLoginButton.addAction(UIAction(handler: { _ in
            print(#fileID, #function, #line, "apple login")
            self.viewModel.loginWithApple()
        }), for: .touchUpInside)
        
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

#if DEBUG

import SwiftUI

#Preview {
    return LoginViewController(viewModel: LoginViewModel())
}

#endif



