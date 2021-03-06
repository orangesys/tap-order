//
//  APISession.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Combine
import Foundation
import UIKit

struct APISession: APIProtocol {
    func request<T>(with builder: RequestBuilder) -> AnyPublisher<T, APIError> where T: Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        print("ssn: \(builder.urlRequest) \(String(describing: builder.urlRequest.httpBody))")

        return URLSession.shared
            .dataTaskPublisher(for: builder.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        let rstNull = (String(decoding: data, as: UTF8.self) == "null")

                        return Just(rstNull ? Data("{\"City\":\"Paris\"}".utf8) : data)
                            .decode(type: T.self, decoder: decoder)
                            .mapError { _ in .decodingError }
                            .eraseToAnyPublisher()
                    } else {
                        return Fail(error: APIError.httpError(response.statusCode))
                            .eraseToAnyPublisher()
                    }
                }
                return Fail(error: APIError.unknown)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
