//
//  String+TapOrder.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/17.
//

import Foundation

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
    
    static func urlStr(req:Request) -> String {
        var urlStr = ""
        let path = "/api/v1/shops/"
        let vendorId = ClipViewModel.shared.vendorId
        let tableId = ClipViewModel.shared.tableId
        var lan = UserViewModel.shared.lang
        if lan.lowercased().hasPrefix("zh") {
            lan = "zh"
        }
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

