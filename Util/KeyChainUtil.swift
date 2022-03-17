//
//  KeyChainUtil.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/16.
//

import KeychainAccess

private let AppleUserIdentifierKey = "kTapOrderAppleUserIdentifier"
private let AppleUserIdentifierVersionKey = "kAppleUserIdentifierVersion"
private let TapOrderAppGroup = "VBHPLCMQNB.io.orangesys.tap-order"

class KeyChainUtil {
    
    static func saveFromApple(_ userIdentifier: String) {
        let keychain = Keychain(service: TapOrderAppGroup)
        do {
            try keychain.set("\(userIdentifier)", key: AppleUserIdentifierKey)
            try keychain.set("\(AppInfo.appVersion),\(AppInfo.buildNumber)", key: AppleUserIdentifierVersionKey)
        } catch let error {
            print(error)
        }
    }
    
    static func fetchFromAppleUser() -> String? {
        let keychain = Keychain(service: TapOrderAppGroup)
        
        var uid: String?
        do {
            uid = try keychain.get(AppleUserIdentifierKey)
        } catch {}
        
        return uid
    }
    
    static func clearAppleID() {
        let keychain = Keychain(service: TapOrderAppGroup)
        do {
            try keychain.remove(AppleUserIdentifierKey)
            try keychain.remove(AppleUserIdentifierVersionKey)
        } catch {}
        
    }
    
}

