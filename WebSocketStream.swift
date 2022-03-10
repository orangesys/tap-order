//
//  WebSocketStream.swift
//  TapOrder
//
//  Created by solo on 2022/2/27.
//

import Foundation


class WebSocketStream: AsyncSequence {
    
    typealias Element = URLSessionWebSocketTask.Message
    typealias AsyncIterator = AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>.Iterator
    
    private var stream: AsyncThrowingStream<Element, Error>?
    private var continuation: AsyncThrowingStream<Element, Error>.Continuation?
    private let socket: URLSessionWebSocketTask
    
    init(url: String, session: URLSession = URLSession.shared) {
        socket = session.webSocketTask(with: URL(string: url)!)
        stream = AsyncThrowingStream { continuation in
            self.continuation = continuation
            self.continuation?.onTermination = { @Sendable [socket] _ in
                socket.cancel()
            }
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        guard let stream = stream else {
            fatalError("stream was not initialized")
        }
        socket.resume()
        //send()
        ping()
        receive()
        //listenForMessages()
        return stream.makeAsyncIterator()
    }
    
//    private func listenForMessages() {
//        socket.receive { [unowned self] result in
//            switch result {
//            case .success(let message):
//                continuation?.yield(message)
//                listenForMessages()
//            case .failure(let error):
//                continuation?.finish(throwing: error)
//            }
//        }
//    }
    
    func receive() {
        socket.receive { result in
            switch result {
            case .success(let message):
                self.continuation?.yield(message)
                self.receive()
            case .failure(let error):
                print("Error when receiving \(error)")
            }
        }
    }
    
    func ping() {
        socket.sendPing { error in
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                print("Web Socket connection is alive")
                DispatchQueue.global().asyncAfter(deadline: .now() + 10) { [self] in
                    ping()
                }
            }
        }
    }

    func close() {
        let reason = "Closing connection".data(using: .utf8)
        socket.cancel(with: .goingAway, reason: reason)
    }

    func send() {
        //DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [self] in
        //    send()
            socket.send(.string("New Message")) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        //}
    }
    
    func sendToCart(food:TONewFoods) {
        
        socket.send(.string("{\"+\":{\"sku_id\":\"\(food.id ?? "food_id")\",\"customer_id\":\"\(TOUserViewModel.shared.userid)\"}}")) { error in
            if let error = error {
                print("Error when sending a message \(error)")
            }
        }
    }
    
    func stringify(json: TONewFoods, prettyPrinted: Bool = false) -> String {
        do {
            let jsonData = try JSONEncoder().encode(json)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString ?? ""
        }catch {
            print("error: \(error)")
        }
        
        return ""
    }

}
