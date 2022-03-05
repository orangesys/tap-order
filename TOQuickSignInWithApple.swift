//
//  TOQuickSignInWithApple.swift
//  TapOrder
//
//  Created by solo on 2022/3/5.
//

import SwiftUI
import AuthenticationServices

struct TOQuickSignInWithApple: UIViewRepresentable {
    typealias UIViewType = ASAuthorizationAppleIDButton
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let bt = ASAuthorizationAppleIDButton(type:.signIn, style: .white)
        bt.cornerRadius = 30
        return bt

    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
  }

