//
//  TapOrderApp.swift
//  Shared
//
//  Created by solo on 2/21/22.
//

import SwiftUI
import Combine

@main
struct TapOrderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject var contentViewModel = ContentViewModel.shared
    @State var needShowLogin: Bool = SignInWithApple.didExitUser()
    init() {
      
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(needShowLogin: $needShowLogin).onReceive(contentViewModel.needShowLoginPublisher) {
                self.needShowLogin = $0
            }
        }
    }
}
