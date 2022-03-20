//
//  CartViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/24/22.
//

import Foundation
import Combine
import SwiftUI
import Network

class OrderViewModel: ObservableObject, WebSocketConnectionDelegate {
    
    @Published var newOrderList =  [CartItem]()
    @Published var isError = false
    @Published var totalStr = ""
    
    var errorStr = ""
    var isBackgroundLoading = false

    var cancellables = Set<AnyCancellable>()
    
    func webSocketDidReceiveError(connection: WebSocketConnection, error: NWError) {
        print("order ws: \(error)")
        socket?.disconnect()
    }
    
    func webSocketViabilityDidChange(connection: WebSocketConnection, isViable: Bool) {
        
    }
    
    func webSocketDidAttemptBetterPathMigration(result: Result<WebSocketConnection, NWError>) {
        
    }
    
    var socket: NWWebSocket?
    
    init(urlstr:String) {
        self.buildConnect(urlstr: urlstr)
    }
    
    func reConnect() {
        socket = nil
        self.buildConnect(urlstr: String.urlStr(req: .order))
    }
    
    func buildConnect(urlstr:String) {
        print("ws ws 3: \(urlstr)")
        socket = NWWebSocket(url: URL(string: "\(urlstr)")!, connectAutomatically: true)
        socket?.ping(interval: 10)
        socket?.delegate = self
    }
    
    // Delegates
    func webSocketDidConnect(connection: WebSocketConnection) {
        print("connected 2")
    }
    
    func webSocketDidDisconnect(connection: WebSocketConnection, closeCode: NWProtocolWebSocket.CloseCode, reason: Data?) {
        print("disconnected 2")
        self.reConnect()
    }
    
    func webSocketDidReceiveMessage(connection: WebSocketConnection, string: String) {
        let data = string.data(using: .utf8)!
        do {
            let fjson = try JSONDecoder().decode(CartResponse.self, from: data)
            print("Text received \(string), \(fjson.items.count)")
            //print(fjson)
            //print(fjson.items.map({$0.value}))
            let farrJson = fjson.items.map({$0.value})
//            let currentUser = UserViewModel.shared.userid
//            var currentUserValue = [CartItem]()
//            let groupUserDic = Dictionary(grouping: farrJson) {$0.userId}
//                .filter() {
//                    // array first to group by dic
//                    // and filter current user
//                    if currentUser == $0.key {
//                        currentUserValue = $0.value
//                    }
//                    return currentUser != $0.key
//                }
//            //print(groupUserDic)
//            // 排序当前用户最上面
//            var allarr:[CartItem] = groupUserDic.flatMap({$0.value})
//            allarr.insert(contentsOf: currentUserValue, at: 0)
            self.newOrderList = farrJson
            self.totalStr = "\(fjson.total)"
        } catch {
            print(error)
        }
    }
    
    func webSocketDidReceiveMessage(connection: WebSocketConnection, data: Data) {
        
    }

    func webSocketDidReceivePong(connection: WebSocketConnection) {
        print("received pong 2")
    }
}
