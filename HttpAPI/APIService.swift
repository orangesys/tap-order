//
//  APIService.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Combine
import Foundation
import UIKit

protocol APIService {
    var apiSession: APIProtocol { get }

    func getFoodsCat() -> AnyPublisher<[String: NewFoodsCat], APIError>
    func getFoodsCatList(cat: String) -> AnyPublisher<[String: NewFoods], APIError>
    func getFoodsList() -> AnyPublisher<FoodsResposne, APIError>
    func postCart(cartSend: CartItemSend) -> AnyPublisher<[String: String], APIError>
    func delCart(delId: String) -> AnyPublisher<[String: String], APIError>
    func createPayOrder(orderInfo: String) -> AnyPublisher<[String: String], APIError>
    func getCartList2() -> AnyPublisher<[String: CartItem], APIError>
}

extension APIService {
    func getFoodsCat() -> AnyPublisher<[String: NewFoodsCat], APIError> {
        return apiSession.request(with: APIRequest.foodCat)
            .eraseToAnyPublisher()
    }

    func getFoodsCatList(cat: String) -> AnyPublisher<[String: NewFoods], APIError> {
        return apiSession.request(with: APIRequest.foodCatList(cat))
            .eraseToAnyPublisher()
    }

    func getFoodsList() -> AnyPublisher<FoodsResposne, APIError> {
        return apiSession.request(with: APIRequest.foodList)
            .eraseToAnyPublisher()
    }

    func postCart(cartSend: CartItemSend) -> AnyPublisher<[String: String], APIError> {
        return apiSession.request(with: APIRequest.postCart(cartSend))
            .eraseToAnyPublisher()
    }

    func delCart(delId: String) -> AnyPublisher<[String: String], APIError> {
        return apiSession.request(with: APIRequest.delCart(delId))
            .eraseToAnyPublisher()
    }

    func getCartList2() -> AnyPublisher<[String: CartItem], APIError> {
        return apiSession.request(with: APIRequest.cartList2)
            .eraseToAnyPublisher()
    }

    func createPayOrder(orderInfo: String) -> AnyPublisher<[String: String], APIError> {
        return apiSession.request(with: APIRequest.createPayOrder(orderInfo))
            .eraseToAnyPublisher()
    }
}
