//
//  TOSocket.swift
//  TapOrder
//
//  Created by solo on 2022/2/27.
//

import Foundation

class WebSocket: NSObject, URLSessionWebSocketDelegate {
    static let shared = WebSocket()
    
//    static let webSocketTask : URLSessionWebSocketTask = {
//        let webSocketDelegate = WebSocket.shared
//        let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
//        let url = URL(string: "ws://localhost:8080")!
//        //let url = URL(string: "ws:/35.72.33.86:8080")!
//        let webSocketTask = session.webSocketTask(with: url)
//        //webSocketTask.resume()
//        return webSocketTask
//    }()
//
//    static func ping() {
//        webSocketTask.sendPing { error in
//            if let error = error {
//                print("Error when sending PING \(error)")
//            } else {
//                print("Web Socket connection is alive")
//                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
//                    self.ping()
//                }
//            }
//        }
//    }
//
//    static func close() {
//        let reason = "Closing connection".data(using: .utf8)
//        webSocketTask.cancel(with: .goingAway, reason: reason)
//    }
//
//    static func send() {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//            self.send()
//            self.webSocketTask.send(.string("New Message")) { error in
//                if let error = error {
//                    print("Error when sending a message \(error)")
//                }
//            }
//        }
//    }
//
//    static func receive() {
//        self.webSocketTask.receive { result in
//            switch result {
//            case .success(let message):
//                switch message {
//                case .data(let data):
//                    print("Data received \(data)")
//                case .string(let text):
//                    print("Text received \(text)")
//                }
//            case .failure(let error):
//                print("Error when receiving \(error)")
//            }
//
//            self.receive()
//        }
//    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
        TOSocketUse.one.ping()
        TOSocketUse.one.send()
        TOSocketUse.one.receive()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
}

