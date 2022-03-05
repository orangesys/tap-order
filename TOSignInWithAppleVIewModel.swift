//
//  TOSignInWithAppleVIewModel.swift
//  TapOrder
//
//  Created by solo on 2022/3/5.
//

import Foundation
import SwiftUI
import AuthenticationServices

enum TOLoginStatus {
    case notLogin
    case sucessNormalLogin
    case sucessNewLogin
    case failLogin
}

class TOSignInWithAppleVIewModel: NSObject, ASAuthorizationControllerDelegate, ObservableObject {
    @Published var isSuccessLogin: TOLoginStatus = .notLogin
    private weak var swindow: UIWindow!
    init(window: UIWindow?) {
        self.swindow = window
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            print("\n ** ASAuthorizationAppleIDCredential - \(#function)** \n")
            print(appleIdCredential.email ?? "Email not available.")
            print(appleIdCredential.fullName ?? "fullname not available")
            print(appleIdCredential.fullName?.givenName ?? "givenName not available")
            print(appleIdCredential.fullName?.familyName ?? "Familyname not available")
            print(appleIdCredential.user)  // This is a user identifier
            print(appleIdCredential.identityToken?.base64EncodedString() ?? "Identity token not available") //JWT Token
            print(appleIdCredential.authorizationCode?.base64EncodedString() ?? "Authorization code not available")
            
            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                // Apple has autherized the use with Apple ID and password
                registerNewUser(credential: appleIdCredential)
            } else {
                // User has been already exist with Apple Identity Provider
                signInExistingUser(credential: appleIdCredential)
            }
            
            break
            
        case let passwordCredential as ASPasswordCredential:
            print("\n ** ASPasswordCredential ** \n")
            print(passwordCredential.user)  // This is a user identifier
            print(passwordCredential.password) //The password
            print("\n ** ASPasswordCredential ** \n")
            signinWithUserNamePassword(credential: passwordCredential)
            break
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\n -- ASAuthorizationControllerDelegate -\(#function) -- \n")
        print(error)
        self.isSuccessLogin = .failLogin
    }
}

extension TOSignInWithAppleVIewModel {
    private func registerNewUser(credential: ASAuthorizationAppleIDCredential) {
        // API Call - Pass the email, user full name, user identity provided by Apple and other details.
        // Give Call Back to UI
        self.isSuccessLogin = .sucessNewLogin
        swindow.rootViewController = UIHostingController(rootView: TOMainView())
        swindow.makeKeyAndVisible()
    }
    
    private func signInExistingUser(credential: ASAuthorizationAppleIDCredential) {
        // API Call - Pass the user identity, authorizationCode and identity token
        // Give Call Back to UI
        self.isSuccessLogin = .sucessNormalLogin
        swindow.rootViewController = UIHostingController(rootView: TOMainView())
        swindow.makeKeyAndVisible()
    }
    
    private func signinWithUserNamePassword(credential: ASPasswordCredential) {
        // API Call - Sign in with Username and password
        // Give Call Back to UI
        
    }
}
