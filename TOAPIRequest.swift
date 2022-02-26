//
//  TOAPIRequest.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation


enum TOAPIRequest {
    case foodList
    case postCart(TOCartItemSend)
    case delCart(String)
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
        case .postCart(let one):
            
            guard let url = URL(string: "https://tap-open-default-rtdb.asia-southeast1.firebasedatabase.app/postCart.json")
                else {preconditionFailure("Invalid URL format")}
            
            var request = URLRequest(url: url)
            request.httpMethod = "Post"
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonData = try JSONEncoder().encode(one)
                request.httpBody = jsonData
            }catch let jsonErr{
                print(jsonErr)
            }

            return request
        case .delCart(let one):
            
            guard let url = URL(string: "https://tap-open-default-rtdb.asia-southeast1.firebasedatabase.app/postCart/\(one).json")
                else {preconditionFailure("Invalid URL format")}
            
            var request = URLRequest(url: url)
            request.httpMethod = "Delete"
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonData = try JSONEncoder().encode(one)
                request.httpBody = jsonData
            }catch let jsonErr{
                print(jsonErr)
            }

            return request
        case .cartList2:
            
            guard let url = URL(string: "https://tap-open-default-rtdb.asia-southeast1.firebasedatabase.app/postCart.json")
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
        }
        
    }
}
