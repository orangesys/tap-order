//
//  APIRequest.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation

enum Request {
    case cat
    case foods(String)
    case cart
    case order
}

enum APIRequest {
    case foodCat
    case foodCatList(String)
    case foodList
    case postCart(CartItemSend)
    case delCart(String)
    case cartList2
}

extension APIRequest: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .foodCat:
            guard let url = URL(string: String.urlStr(req: .cat))
                else {preconditionFailure("Invalid URL format")}
            var request = URLRequest(url: url)
            request.addValue(UserViewModel.shared.userid, forHTTPHeaderField: "Authorization")
            return request
        case .foodCatList(let cat):
            guard let url = URL(string: String.urlStr(req: .foods(cat)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                else {preconditionFailure("Invalid URL format")}
            var request = URLRequest(url: url)
            request.addValue(UserViewModel.shared.userid, forHTTPHeaderField: "Authorization")
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
