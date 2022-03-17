//
//  KeyChainUtil.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/16.
//

import KeychainAccess

private let AppleUserIdentifierKey = "kTapOrderAppleUserIdentifier"
private let AppleUserIdentifierVersionKey = "kAppleUserIdentifierVersion"
private let TapOrderAppGroup = "group.oeoly.TapOrder"

class KeyChainUtil {
    
    static func saveFromApple(_ userIdentifier: String) {
        let keychain = Keychain(accessGroup: TapOrderAppGroup)
        do {
            try keychain.set("\(userIdentifier)", key: AppleUserIdentifierKey)
            try keychain.set("\(AppInfo.appVersion),\(AppInfo.buildNumber)", key: AppleUserIdentifierVersionKey)
        } catch {}
    }
    
    static func fetchFromAppleUser() -> String? {
        let keychain = Keychain(accessGroup: TapOrderAppGroup)
        
        var uid: String?
        do {
            uid = try keychain.get(AppleUserIdentifierKey)
        } catch {}
        
        return uid
    }
    
    static func clearAppleID() {
        let keychain = Keychain(accessGroup: TapOrderAppGroup)
        do {
            try keychain.remove(AppleUserIdentifierKey)
            try keychain.remove(AppleUserIdentifierVersionKey)
        } catch {}
        
    }
    
}

