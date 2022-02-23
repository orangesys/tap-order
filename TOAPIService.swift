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
    //func getPokemon(pokemonURL: String) -> AnyPublisher<Pokemon, APIError>
}

extension TOAPIService {
    
    func getFoodsList() -> AnyPublisher<TOFoodsResposne, APIError> {
        return apiSession.request(with: TOAPIRequest.foodList)
            .eraseToAnyPublisher()
    }
    
//    func getPokemon(pokemonURL: String) -> AnyPublisher<Pokemon, APIError> {
//        return apiSession.request(with: PokemonEndpoint.pokemonDetail(pokemonURL))
//            .eraseToAnyPublisher()
//    }
}

