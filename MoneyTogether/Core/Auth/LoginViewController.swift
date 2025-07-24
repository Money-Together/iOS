//
//  LoginViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 7/20/25.
//

import Foundation
import UIKit
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
            
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                guard error == nil else { return }
                guard let signInResult = signInResult else { return }
                
                print(#fileID, #function, #line, "sign in success")
                
                signInResult.user.refreshTokensIfNeeded { user, error in
                    guard error == nil else { return }
                    guard let user = user else { return }
                    
                    guard let idToken = user.idToken else { return }
                    print(#fileID, #function, #line, "token: \(idToken.tokenString)")
                    self.testAPIRequest(token: idToken.tokenString)
                    // Send ID token to backend (example below).
                }
                
                // If sign in succeeded, display the app's main content View.
                
            }
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
