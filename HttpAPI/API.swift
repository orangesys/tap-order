//
//  API.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Combine
import Foundation
import UIKit

enum APIError: Error {
    case decodingError
    case httpError(Int)
    case unknown
}

protocol RequestBuilder {
    var urlRequest: URLRequest { get }
}

protocol APIProtocol {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, APIError>
}
