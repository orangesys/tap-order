//
//  TOUtils.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import UIKit
import SwiftUI

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension Font {
    static var  toOrderFont: Font {
        return .system(size: 20, weight: .bold)
    }
}

extension Color {
    static var themeColor: Color {
        return Color(uiColor: UIColor(rgb: 0x6644AB))
    }
    static var normalGray: Color {
        return Color(uiColor: UIColor(rgb: 0xeeeeee))
    }
    static var normalGreen: Color {
        return Color(uiColor: UIColor(rgb: 0x18794B))
    }
    static var normalYellow: Color {
        return Color(uiColor: UIColor(rgb: 0xDCB21C))
    }
    static var normalRed: Color {
        return Color(uiColor: UIColor(rgb: 0xBD2727))
    }
    static var toastRed: Color {
        return Color(uiColor: UIColor(rgb: 0xDA615C))
    }
}

extension CGFloat {
    static let menuListPadding = CGFloat(35)
    static let menuListCatgoryPadding = CGFloat(14)
    
    static var menuListContent: CGFloat {
        return SCREENWIDTH - menuListPadding * 2
    }
    static var SCREENWIDTH: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var TOMenuCardWidth: CGFloat {
        return (( SCREENWIDTH - menuListPadding * 3 ) * 0.5)
    }
    static var TOMenuCatgoryWidth: CGFloat {
        return ((SCREENWIDTH - menuListPadding * 2 - menuListCatgoryPadding * 3) / 4)
    }
    static var TopSafePadding: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        return window?.safeAreaInsets.top ?? 44.0
    }
}

extension Double {
    func round2Str() -> String {
        return String(format: "%.2f", self)
    }
}
    
extension UITabBarController {
    open override func viewWillLayoutSubviews() {
        let array = self.viewControllers
        for controller in array! {
            controller.tabBarItem.title = ""
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
        }
    }
}

extension String {
//    #if DEBUG
//    static let APIHost = "http://\(APIDomain)"
//    static let WSHost = "ws://\(APIDomain)"
//    private static let APIDomain = "localhost:8080"
//    #else
    static let APIHost = "https://\(APIDomain)"
    static let WSHost = "wss://\(APIDomain)"
    private static let APIDomain = "tap-order.orangesys.io"
//    #endif
    
    func encodeBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    static func urlStr(req:TORequest) -> String {
        var urlStr = ""
        let path = "/api/v1/shops/"
        let vendorId = TOClipViewModel.shared.vendorId
        let tableId = TOClipViewModel.shared.tableId
        let lan = TOUserViewModel.shared.lang
        switch req {
        case .cat:
            urlStr = "\(APIHost)\(path)\(vendorId)/categories?language=\(lan)"
        case .foods(let cat):
            urlStr = "\(APIHost)/api/v1/shops/\(vendorId)/categories/\(cat)?language=\(lan)"
        case .cart:
            urlStr = "\(String.WSHost)\(path)\(vendorId)/tables/\(tableId)/carts?language=\(lan)"
        case .order:
            urlStr = "\(String.WSHost)\(path)\(vendorId)/tables/\(tableId)/current-order?language=\(lan)"
        }
        
        return urlStr
    }
}

extension View {
    func sbadge(count: Int) -> some View {
        overlay(
            ZStack {
                if count != 0 {
                    Circle()
                        .fill(Color.red)
                    Text("\(count)")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
            .offset(x: 12, y: -12)
            .frame(width: 24, height: 24)
        , alignment: .topTrailing)
    }
}
