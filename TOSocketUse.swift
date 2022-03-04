//
//  TOSocketUse.swift
//  TapOrder
//
//  Created by solo on 2022/2/27.
//

import Foundation

class TOSocketUse: NSObject {
    static var one = TOSocketUse()
    
    static var shared : URLSessionWebSocketTask  {
            let webSocketDelegate = WebSocket.shared
            let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
            let url = URL(string: "ws://localhost:8080")!
            //let url = URL(string: "ws:/35.72.33.86:8080")!
            let webSocketTask = session.webSocketTask(with: url)
            //webSocketTask.resume()
        return webSocketTask
        }
    
    func ping() {
        TOSocketUse.shared.sendPing { error in
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                print("Web Socket connection is alive")
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self.ping()
                }
            }
        }
    }

    func close() {
        let reason = "Closing connection".data(using: .utf8)
        TOSocketUse.shared.cancel(with: .goingAway, reason: reason)
    }

    func send() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.send()
            TOSocketUse.shared.send(.string("New Message")) { error in
                if let error = error {
                    print("Error when sending a message \(error)")
                }
            }
        }
    }

    func receive() {
        TOSocketUse.shared.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Data received \(data)")
                case .string(let text):
                    print("Text received \(text)")
                }
            case .failure(let error):
                print("Error when receiving \(error)")
            }

            self.receive()
        }
    }
}
