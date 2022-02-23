//
//  TOAPIRequest.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation


enum TOAPIRequest {
    case foodList
    case pokemonDetail(String)
}

extension TOAPIRequest: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .foodList:
            guard let url = URL(string: "https://tap-open-default-rtdb.asia-southeast1.firebasedatabase.app/foods.json")
                else {preconditionFailure("Invalid URL format")}
            let request = URLRequest(url: url)
            return request
        case .pokemonDetail(let pokemonURL):
            
            guard let url = URL(string: pokemonURL)
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
        }
        
    }
}
