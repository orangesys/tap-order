//
//  TapOrderClipApp.swift
//  TapOrderClip
//
//  Created by solo on 2022/2/26.
//

import SwiftUI
import Combine
import StripeCore
@main
struct TapOrderClipApp: App {
    @ObservedObject var contentViewModel = ContentViewModel.shared
    @State var rootPage: RootPage = SignInWithApple.didExitUser() ? RootPage.main : RootPage.start
    init() {
        #if DEBUG
        StripeAPI.defaultPublishableKey = "pk_test_ttdLzgFVASAg87YVXpbBl2Ku"
        #else
        StripeAPI.defaultPublishableKey = "pk_live_CvWJdjGhMMZf1dsGyXZh2J2i"
        #endif
        StripeAPI.additionalEnabledApplePayNetworks = PaymentHandler.supportedNetworks
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(rootPage: $rootPage).onReceive(contentViewModel.rootPagePublisher) {
                self.rootPage = $0
            }
        }
    }
}
