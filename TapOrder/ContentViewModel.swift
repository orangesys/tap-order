//
//  ContentViewModel.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/17.
//

import Combine

enum RootPage {
    case start
    case main
}

class ContentViewModel: ObservableObject {
    static let shared = ContentViewModel()
    var needShowLoginPublisher = PassthroughSubject<Bool, Never>()
    private init() {
//        KeyChainUtil.clearAppleID() // For test
    }
    
    func checkIfUserLogin() {
        needShowLoginPublisher.send(!SignInWithApple.didExitUser())
    }
}
