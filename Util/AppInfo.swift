//
//  AppInfo.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/16.
//

import Foundation

open class AppInfo {
    /// Return the main application bundle. If this is called from an extension, the containing app bundle is returned.
    public static var applicationBundle: Bundle {
        let bundle = Bundle.main
        switch bundle.bundleURL.pathExtension {
        case "app":
            return bundle
        case "appex":
            // .../Client.app/PlugIns/SendTo.appex
            return Bundle(url: bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent())!
        default:
            fatalError("Unable to get application Bundle (Bundle.main.bundlePath=\(bundle.bundlePath))")
        }
    }

    public static var displayName: String {
        return applicationBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }

    public static var appVersion: String {
        return applicationBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    public static var buildNumber: String {
        return applicationBundle.object(forInfoDictionaryKey: String(kCFBundleVersionKey)) as! String
    }

    public static var majorAppVersion: String {
        return appVersion.components(separatedBy: ".").first!
    }

    /// Return the base bundle identifier.
    ///
    /// This function is smart enough to find out if it is being called from an extension or the main application. In
    /// case of the former, it will chop off the extension identifier from the bundle since that is a suffix not part
    /// of the *base* bundle identifier.
    public static var baseBundleIdentifier: String {
        let bundle = Bundle.main
        let packageType = bundle.object(forInfoDictionaryKey: "CFBundlePackageType") as! String
        let baseBundleIdentifier = bundle.bundleIdentifier!
        if packageType == "XPC!" {
            let components = baseBundleIdentifier.components(separatedBy: ".")
            return components[0..<components.count-1].joined(separator: ".")
        }
        return baseBundleIdentifier
    }

    // Return whether the currently executing code is running in an Application
    public static var isApplication: Bool {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundlePackageType") as! String == "APPL"
    }
    
    public static var isTestFlight: Bool {
        guard let appstoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            return false
        }
        return appstoreReceiptURL.lastPathComponent == "sandboxReceipt"
    }

}

