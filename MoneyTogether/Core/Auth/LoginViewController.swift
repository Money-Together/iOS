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

class LoginViewController: UIViewController {
    
    private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .yellow
        
        loginButton = CTAUIButton(activeState: .active, buttonStyle: .solid, labelText: "구글로 로그인", action: {
            print(#fileID, #function, #line, "do login")
            self.doGoogleSocialLogin()
        })
        
        view.addSubview(loginButton)
    }
    
    private func setLayout() {
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150)
        ])
    }
    
    func doGoogleSocialLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] signInResult, error in
            guard error == nil else {
                print(#fileID, #function, #line, "❌ Error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let user = signInResult?.user,
                  let googleIdToken = user.idToken?.tokenString else {
                print(#fileID, #function, #line, "❌ Error: no google token")
                return
            }
            
            // firebase 사용자 인증 정보 (with google idToken)
            let credential = GoogleAuthProvider.credential(withIDToken: googleIdToken, accessToken: user.accessToken.tokenString)
            doFirebaseLogin(credential: credential)
            
        }
    }
    
    func doFirebaseLogin(credential: AuthCredential) {
        // firebase login
        Auth.auth().signIn(with: credential) { result, error in
            guard error == nil else {
                print(#fileID, #function, #line, "❌ Error: \(error?.localizedDescription ?? "Unknown error"))")
                return
            }
            
            guard let user = Auth.auth().currentUser else {
                print(#fileID, #function, #line, "❌ Error: No current user signed in Firebase ")
                return
            }
            
            user.getIDToken { idToken, error in
                guard let idToken = idToken, error == nil else {
                    print("❌ Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // 서버 로그인
                self.testAPIRequest(token: idToken)
            }
        }
    }
    
    func testAPIRequest(token: String) {
        guard let url = URL(string: "http://localhost:8080/auth/google") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "idToken": token
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("❌ Failed to encode JSON: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("✅ Response code: \(response.statusCode)")
            }
            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("📦 Response body: \(responseBody)")
            }
        }
        task.resume()
    }
}


#if DEBUG

import SwiftUI
import GoogleSignIn

#Preview {
    return LoginViewController()
}

#endif
