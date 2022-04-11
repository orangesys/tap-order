//
//  CartViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/24/22.
//

import Combine
import Network
import PassKit
import SwiftUI

enum InCartAction {
    case remove
    case plusOne
    case subtractOne
}

class CartViewModel: ObservableObject, APIService {
    @Published var paymentSheet: Any?
    @Published var paymentResult: Any?

    @Published var newCartList = [CartItem]()
    @Published var badgeNum = 0
    @Published var numbelString = ""
    @Published var isLoading = false
    @Published var paying = false
    @Published var isError = false
    @Published var totalStr = ""

    private var newCartListEmpty: AnyPublisher<Bool, Never> {
        return $newCartList.map { items in
            items.isEmpty
        }.eraseToAnyPublisher()
    }

    private var isPaying: AnyPublisher<Bool, Never> {
        return $paying.map { isDoing in
            isDoing
        }.eraseToAnyPublisher()
    }

    var sendDisabled: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(self.newCartListEmpty, self.isPaying)
            .map { _,_ in
                false
            }
            .eraseToAnyPublisher()
    }

    var cancellables = Set<AnyCancellable>()
    var apiSession: APIProtocol
    
    let paymentHandler = PaymentHandler()
    var errorStr = ""
    var isBackgroundLoading = false

    var socket: NWWebSocket?

    init(urlstr: String, apiSession: APIProtocol = APISession()) {
        self.apiSession = apiSession

        print("ws ws 1: \(urlstr)")
        self.buildConnect(urlstr: urlstr)
    }

    func buildConnect(urlstr: String) {
        print("ws ws 2: \(urlstr)")
        self.socket = NWWebSocket(url: URL(string: "\(urlstr)")!, connectAutomatically: true)
        self.socket?.ping(interval: 10)
        self.socket?.delegate = self
    }

    func reConnect() {
        self.socket = nil
        self.buildConnect(urlstr: String.urlStr(req: .cart))
    }

    func receives() {}

    /// add from menu list
    /// - Parameter food: food object
    func sendToCart(food: NewFoods, isPlus: Bool = false) {
        self.isLoading = true
        var food2 = food
        food2.customer_id = UserViewModel.shared.userid
        food2.count = 1
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode([food2]), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)

            self.socket?.send(string: "{\"+\":\(jsonString)}")
        }
    }

    func updateFoodInCart(_ food: CartItem, action: InCartAction) {
        self.isLoading = true
        var food2 = food
        var symbol = "~"
        if action == .plusOne {
            food2.count = food2.count + 1
        } else if action == .subtractOne {
            food2.count = food2.count - 1
        } else if action == .remove {
            symbol = "-"
        }

        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode([food2]), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)

            self.socket?.send(string: "{\"\(symbol)\":\(jsonString)}")
        }
    }

    private func doSomething() {
        let mycarts = self.newCartList.filter { $0.userId == UserViewModel.shared.userid }
        self.placeOrder(foods: mycarts)
    }

    func placeOrder(foods: [CartItem]) {
        self.isLoading = true
        var sendDic = [CartSendOrder]()
        for one in foods {
            sendDic.append(CartSendOrder(uuid: one.sid))
        }
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(sendDic), let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)

            self.socket?.send(string: "{\"=\":\(jsonString)}")
        }
    }

    func callApplePay() {
        guard let total = Int(totalStr), total > 0, paying == false else {
            return
        }
        self.paying = true
        self.paymentHandler.startPayment(amount: total, completion: { success in
            if success {
                print("Success")
            } else {
                print("Failed")
            }
        })
    }
}

extension CartViewModel: WebSocketConnectionDelegate {
    func webSocketDidReceiveMessage(connection: WebSocketConnection, data: Data) {}

    func webSocketDidReceivePong(connection: WebSocketConnection) {
        print("received pong")
    }

    func webSocketDidReceiveError(connection: WebSocketConnection, error: NWError) {
        print("char ws: \(error)")
        self.socket?.disconnect()
    }

    func webSocketViabilityDidChange(connection: WebSocketConnection, isViable: Bool) {}

    func webSocketDidAttemptBetterPathMigration(result: Result<WebSocketConnection, NWError>) {}

    func webSocketDidConnect(connection: WebSocketConnection) {
        print("connected")
    }

    func webSocketDidDisconnect(connection: WebSocketConnection, closeCode: NWProtocolWebSocket.CloseCode, reason: Data?) {
        print("disconnected")
        self.reConnect()
    }

    func webSocketDidReceiveMessage(connection: WebSocketConnection, string: String) {
        self.isLoading = false
        print("Text received \(string)")
        let data = string.data(using: .utf8)!
        do {
            let fjson = try JSONDecoder().decode(CartResponse.self, from: data)
            // print(fjson)
            // print(fjson.items.map({$0.value}))
            let farrJson = fjson.items.map { $0.value }
            let currentUser = UserViewModel.shared.userid
            var currentUserValue = [CartItem]()
            let groupUserDic = Dictionary(grouping: farrJson) { $0.userId }
                .filter {
                    // array first to group by dic
                    // and filter current user
                    if currentUser == $0.key {
                        currentUserValue = $0.value
                    }
                    return currentUser != $0.key
                }
            // print(groupUserDic)
            // 排序当前用户最上面
            var allarr: [CartItem] = groupUserDic.flatMap { $0.value }
            allarr.insert(contentsOf: currentUserValue, at: 0)
            self.newCartList = allarr

            let numberString = "\(fjson.items.count)"
            self.numbelString = String(format: "N items in cart".localizedString, numberString)
            self.badgeNum = fjson.items.count
            self.totalStr = "\(fjson.total)"
        } catch {
            print(error)
        }
    }
}
