//
//  TOAPIRequest.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation


enum TOAPIRequest {
    case foodList
    case cartList
    case cartList2
}

extension TOAPIRequest: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .foodList:
            guard let url = URL(string: "https://tap-open-default-rtdb.asia-southeast1.firebasedatabase.app/foods.json")
                else {preconditionFailure("Invalid URL format")}
            let request = URLRequest(url: url)
            return request
        case .cartList:
            
            guard let url = URL(string: "https://tap-open-default-rtdb.asia-southeast1.firebasedatabase.app/addCart.json")
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
        case .cartList2:
            
            guard let url = URL(string: "https://tap-open-default-rtdb.asia-southeast1.firebasedatabase.app/postCart.json")
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
        }
        
    }
}
