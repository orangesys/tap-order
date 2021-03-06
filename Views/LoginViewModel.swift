//
//  LoginViewModel.swift
//  TapOrder
//
//  Created by solo on 2022/3/5.
//

import Combine
import Foundation

enum LoginStatus {
    case notLogin
    case sucessNormalLogin
    case sucessNewLogin
    case failLogin
}

class LoginViewModel: ObservableObject {
    @Published var loginStatus: LoginStatus = .notLogin
    
    private var cancellableSet: Set<AnyCancellable> = []
    private lazy var appleLogin = SignInWithApple()
//    private lazy var userLogin = SelfServiceLoginInWithApple()

    func signInWithApple() {
        appleLogin.publisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .failure:
                    self.loginStatus = .failLogin
                case .finished:
                    break
                }
            }, receiveValue: { user in
                self.loginStatus = user.isNew ? .sucessNewLogin : .sucessNormalLogin
                ContentViewModel.shared.needShowLoginPublisher.send(false)
            })
            .store(in: &cancellableSet)

        appleLogin.internalPublisher
            .receive(on: RunLoop.main)
            .sink { user in
                // API Call - Sign in with Username and password
                // Give Call Back to UI
            }.store(in: &cancellableSet)
        
        appleLogin.login()
    }
}
