//
//  TOAPIService.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation
import Combine
import UIKit

protocol TOAPIService {
    var apiSession: APIService {get}
    
    func getFoodsList() -> AnyPublisher<TOFoodsResposne, APIError>
    func postCart(cartSend:TOCartItemSend) -> AnyPublisher<[String:String], APIError>
    func delCart(delId:String) -> AnyPublisher<[String:String], APIError>
    func getCartList2() -> AnyPublisher<[String:TOCartItem], APIError>
}

extension TOAPIService {
    
    func getFoodsList() -> AnyPublisher<TOFoodsResposne, APIError> {
        return apiSession.request(with: TOAPIRequest.foodList)
            .eraseToAnyPublisher()
    }
    func postCart(cartSend:TOCartItemSend) -> AnyPublisher<[String:String], APIError> {
        return apiSession.request(with: TOAPIRequest.postCart(cartSend))
            .eraseToAnyPublisher()
    }
    func delCart(delId:String) -> AnyPublisher<[String:String], APIError> {
        return apiSession.request(with: TOAPIRequest.delCart(delId))
            .eraseToAnyPublisher()
    }
    func getCartList2() -> AnyPublisher<[String : TOCartItem], APIError> {
        return apiSession.request(with: TOAPIRequest.cartList2)
            .eraseToAnyPublisher()
    }

//    func getPokemon(pokemonURL: String) -> AnyPublisher<Pokemon, APIError> {
//        return apiSession.request(with: PokemonEndpoint.pokemonDetail(pokemonURL))
//            .eraseToAnyPublisher()
//    }
}

