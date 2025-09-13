//
//  SocialLoginType.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/13/25.
//

import Foundation
import FirebaseAuth

enum SocialLoginType {
    case google(idToken: String, accessToken: String?)
    case apple(idToken: String, nonce: String?)
    
    var name: String {
        switch self {
        case .google: return "google"
        case .apple: return "apple"
        }
    }
    
    var credential: AuthCredential {
        switch self {
        case .google(let idToken, let accessToken):
            return GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken ?? ""
            )
        case .apple(let idToken, let nonce):
            return OAuthProvider.appleCredential(
                withIDToken: idToken,
                rawNonce: nonce,
                fullName: nil
            )
        }
    }
}
