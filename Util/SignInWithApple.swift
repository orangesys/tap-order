//
//  SignInWithApple.swift
//  TapOrder (iOS)
//
//  Created by Felix Yuan on 2022/3/16.
//

import AuthenticationServices
import Combine
import LetterAvatarKit

struct AppleUser {
    let name: PersonNameComponents?
    let email: String?
    let isNew: Bool
}

struct iCloudUser {
    let name: String
    let password: String
}

class SignInWithApple: NSObject {
    private let appleUserPublisher = PassthroughSubject<AppleUser, Error>()
    private let internalUserPublisher = PassthroughSubject<iCloudUser, Never>()
    
    private lazy var provider = ASAuthorizationAppleIDProvider()
    var publisher: AnyPublisher<AppleUser, Error>
    var internalPublisher: AnyPublisher<iCloudUser, Never>
    
    override init() {
        publisher = appleUserPublisher.eraseToAnyPublisher()
        internalPublisher = internalUserPublisher.eraseToAnyPublisher()
        super.init()
    }
    
    func login() {
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    func logout() {
        KeyChainUtil.clearAppleID()
    }
    
    static func didExitUser() -> Bool {
        guard let userID = KeyChainUtil.fetchFromAppleUser() else {
            return false
        }
        UserViewModel.shared.userid = userID
        return true

//        let state: ASAuthorizationAppleIDProvider.CredentialState = (try? await provider.credentialState(forUserID: userID)) ?? .notFound
//        return state == .authorized
    }
    
    static func randomNickname() -> String {
        let groupUserDefaults = UserDefaults(suiteName: "group.oeoly.TapOrder")
        if let name = groupUserDefaults?.value(forKey: "RandomNickname"), let notNilName = name as? String {
            return notNilName
        }
        let nickname = "\(Lorem.firstName) \(Lorem.lastName) "
        groupUserDefaults?.set(nickname, forKey: "RandomNickname")
        return nickname
    }
    
    private func saveUserInKeychain(_ uid: String) {
        if let userid = uid.encodeBase64() {
            UserViewModel.shared.userid = userid
        }
        KeyChainUtil.saveFromApple(uid)
    }
    
    private func saveUserInUserDefaults(_ uid: String) {
        let groupUserDefaults = UserDefaults(suiteName: "group.oeoly.TapOrder")
        groupUserDefaults?.set(uid, forKey: "SavedUserID")
    }
}

extension SignInWithApple: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            print("\n ** ASAuthorizationAppleIDCredential - \(#function)** \n")
            print(appleIDCredential.email ?? "Email not available.")
            print(appleIDCredential.fullName ?? "fullname not available")
            print(appleIDCredential.fullName?.givenName ?? "givenName not available")
            print(appleIDCredential.fullName?.familyName ?? "Familyname not available")
            print(appleIDCredential.user) // This is a user identifier
            print(appleIDCredential.identityToken?.base64EncodedString() ?? "Identity token not available") // JWT Token
            print(appleIDCredential.authorizationCode?.base64EncodedString() ?? "Authorization code not available")
            
            var isNew = true
            if let _ = appleIDCredential.email, let _ = appleIDCredential.fullName {
                isNew = false
            }
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            saveUserInKeychain(userIdentifier)
            
            let user = AppleUser(name: fullName, email: email, isNew: isNew)
            appleUserPublisher.send(user)
            
        case let passwordCredential as ASPasswordCredential:
            
            print("\n ** ASPasswordCredential ** \n")
            print(passwordCredential.user) // This is a user identifier
            print(passwordCredential.password) // The password
            print("\n ** ASPasswordCredential ** \n")
            
            let username = passwordCredential.user
            let password = passwordCredential.password
            let user = iCloudUser(name: username, password: password)
            internalUserPublisher.send(user)
            
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\n -- ASAuthorizationControllerDelegate -\(#function) -- \n")
        print(error)
        appleUserPublisher.send(completion: Subscribers.Completion.failure(error))
    }
}
