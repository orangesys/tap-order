//
//  AppDelegate.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/4/8.
//

import Stripe
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        StripeAPI.defaultPublishableKey = "pk_test_ttdLzgFVASAg87YVXpbBl2Ku" 
        #else
        StripeAPI.defaultPublishableKey = "pk_live_CvWJdjGhMMZf1dsGyXZh2J2i"
        #endif
        
        StripeAPI.additionalEnabledApplePayNetworks = PaymentHandler.supportedNetworks
        return true
    }
    
    // This method handles opening custom URL schemes (for example, "your-app://")
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "OrangeSys, Inc."
        configuration.style = .alwaysLight
        configuration.primaryButtonColor = .red
        configuration.defaultBillingDetails.address.country = "JP"
        configuration.defaultBillingDetails.email = "foo@bar.com"
        configuration.returnURL = "typeorder://"
        configuration.applePay = .init(
          merchantId: "merchant.io.orangesys.tap-order",
          merchantCountryCode: "JP"
        )
        
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a Stripe url – handle the URL normally as you would
        }
        return false
    }

    // This method handles opening universal link URLs (for example, "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool  {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = StripeAPI.handleURLCallback(with: url)
                if (stripeHandled) {
                    return true
                } else {
                    // This was not a Stripe url – handle the URL normally as you would
                }
            }
        }
        return false
    }
}
