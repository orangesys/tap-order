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
                // print("Web Socket connection is alive")
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
    
    
    /// add from menu list
    /// - Parameter food: food object
    func sendToCart(food:NewFoods) {
        var food2 = food
        food2.customer_id = UserViewModel.shared.userid
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(food2), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket.send(.string("{\"+\":\(jsonString)}")) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        }
    }
    
    func addToCart(food:CartItem) {
        var food2 = food
        food2.count = food2.count + 1
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(food2), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket.send(.string("{\"~\":\(jsonString)}")) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        }
    }
    
    func deleteFromCart(food:CartItem) {
        var food2 = food
        food2.count = food2.count - 1
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(food2), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket.send(.string("{\"~\":\(jsonString)}")) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        }
    }
    
    func removeFromCart(food:CartItem) {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(food), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket.send(.string("{\"-\":\(jsonString)}")) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        }
    }
    
    func sendOrder(foods:[CartItem]) {
        var sendDic = [String:CartItem]()
        for one in foods {
            sendDic[one.sid] = one
        }
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(sendDic), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket.send(.string("{\"=\":\(jsonString)}")) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        }
    }

    

    func stringify(json: NewFoods, prettyPrinted: Bool = false) -> String {
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

//extension WebSocketStream: URLSessionWebSocketDelegate {
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
//        print("Web socket opened")
//        
//    }
//
//    
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//        print("Web socket closed")
//    }
//}
