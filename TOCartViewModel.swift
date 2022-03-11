//
//  TOCartViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/24/22.
//

import Foundation
import Combine
import SwiftUI
import Network
import NWWebSocket

class TOCartViewModel: ObservableObject, WebSocketConnectionDelegate {
    
    @Published var cartList =  [[TOCartItemForDel]]() // extraordinary
    @Published var newCartList =  [TOCartItem]()
    @Published var badgeNum = 0
    @Published var isLoading = false
    @Published var isError = false
    @Published var totalStr = ""
    var errorStr = ""
    var isBackgroundLoading = false

    var cancellables = Set<AnyCancellable>()
    
    func webSocketDidReceiveError(connection: WebSocketConnection, error: NWError) {
        print(error)
    }
    
    func webSocketViabilityDidChange(connection: WebSocketConnection, isViable: Bool) {
        
    }
    
    func webSocketDidAttemptBetterPathMigration(result: Result<WebSocketConnection, NWError>) {
        
    }
    
    var socket: NWWebSocket?
    
    init(urlstr:String) {
        socket = NWWebSocket(url: URL(string: "\(urlstr)")!, connectAutomatically: true)
        socket?.delegate = self
    }
    
    // Delegates
    func webSocketDidConnect(connection: WebSocketConnection) {
        print("connected")
    }
    
    func webSocketDidDisconnect(connection: WebSocketConnection, closeCode: NWProtocolWebSocket.CloseCode, reason: Data?) {
        print("disconnected")
    }
    
    func webSocketDidReceiveMessage(connection: WebSocketConnection, string: String) {
        print("Text received \(string)")
        let data = string.data(using: .utf8)!
        do {
            let fjson = try JSONDecoder().decode(TOCartResponse.self, from: data)
            //print(fjson)
            //print(fjson.items.map({$0.value}))
            let farrJson = fjson.items.map({$0.value})
            let currentUser = TOUserViewModel.shared.userid
            var currentUserValue = [TOCartItem]()
            let groupUserDic = Dictionary(grouping: farrJson) {$0.userId}
                .filter() {
                    // array first to group by dic
                    // and filter current user
                    if currentUser == $0.key {
                        currentUserValue = $0.value
                    }
                    return currentUser != $0.key
                }
            //print(groupUserDic)
            // 排序当前用户最上面
            var allarr:[TOCartItem] = groupUserDic.flatMap({$0.value})
            allarr.insert(contentsOf: currentUserValue, at: 0)
            self.newCartList = allarr
            self.badgeNum = fjson.items.count
            self.totalStr = "\(fjson.total)"
        } catch {
            print(error)
        }
    }
    
    func webSocketDidReceiveMessage(connection: WebSocketConnection, data: Data) {
        
    }

    func webSocketDidReceivePong(connection: WebSocketConnection) {
        print("received pong")
    }
    
    func receives() {
        
    }
    
    
    /// add from menu list
    /// - Parameter food: food object
    func sendToCart(food:TONewFoods) {
        var food2 = food
        food2.customer_id = TOUserViewModel.shared.userid
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(food2), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket?.send(string: "{\"+\":\(jsonString)}")
        }
    }
    
    func addToCart(food:TOCartItem) {
        var food2 = food
        food2.count = food2.count + 1
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(food2), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket?.send(string: "{\"~\":\(jsonString)}")
        }
    }
    
    func deleteFromCart(food:TOCartItem) {
        var food2 = food
        food2.count = food2.count - 1
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(food2), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket?.send(string: "{\"~\":\(jsonString)}")
        }
    }
    
    func removeFromCart(food:TOCartItem) {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(food), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket?.send(string: "{\"-\":\(jsonString)}")
        }
    }
    
    func sendOrder(foods:[TOCartItem]) {
        var sendDic = [String:TOCartItem]()
        for one in foods {
            sendDic[one.sid] = one
        }
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(sendDic), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            
            socket?.send(string: "{\"=\":\(jsonString)}")
        }
    }

}
