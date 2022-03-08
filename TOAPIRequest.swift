//
//  TOAPIRequest.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation


enum TOAPIRequest {
    case foodCat
    case foodCatList(String)
    case foodList
    case postCart(TOCartItemSend)
    case delCart(String)
    case cartList2
}

extension TOAPIRequest: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .foodCat:
            guard let url = URL(string: "\(String.APIHost)/api/v1/shops/e988662acc1fe9b08a9e764bacfcb304/categories?language=en")
                else {preconditionFailure("Invalid URL format")}
            let request = URLRequest(url: url)
            return request
        case .foodCatList(let cat):
            guard let url = URL(string: "\(String.APIHost)/api/v1/shops/e988662acc1fe9b08a9e764bacfcb304/categories/\(cat)?language=ja".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                else {preconditionFailure("Invalid URL format")}
            let request = URLRequest(url: url)
            return request
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
