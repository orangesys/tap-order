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

#if !TAPORDERCLIP
import Stripe
#endif

enum InCartAction {
    case remove
    case plusOne
    case subtractOne
}

class CartViewModel: ObservableObject, APIService {
#if TAPORDERCLIP
    @Published var paymentSheet: Any?
    @Published var paymentResult: Any?
#else
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
#endif
   
    @Published var newCartList = [CartItem]()
    @Published var myAddToCart =  [CartItem]()
    @Published var badgeNum = 0
    @Published var numbelString = ""
    @Published var isLoading = false
    @Published var paying = false
    @Published var isError = false
    @Published var totalStr = ""

    private lazy var paymentHandler = PaymentHandler()
    var cancellables = Set<AnyCancellable>()
    var apiSession: APIProtocol

    var errorStr = ""
    var isBackgroundLoading = false

    var socket: NWWebSocket?
    
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
            .map { value2, value1 in
                #if TAPORDERCLIP
                false
                #else
                value2 || value1
                #endif
            }
            .eraseToAnyPublisher()
    }

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

    #if !TAPORDERCLIP
    func preparePaymentSheet() {
        let total = needPayValue()
        guard total > 0, paying == false else {
            doSomething()
            return
        }
        
        self.paying = true
        createPayOrder(orderInfo: ["amount": total]).sink { _ in

        } receiveValue: { json in
            guard let customerId = json["customer"],
                  let customerEphemeralKeySecret = json["ephemeralKey"],
                  let paymentIntentClientSecret = json["paymentIntent"],
                  let publishableKey = json["publishableKey"]
            else {
                self.paying = false
                return
            }

            STPAPIClient.shared.publishableKey = publishableKey

            // MARK: Create a PaymentSheet instance

            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "OrangeSys, Inc."
            configuration.applePay = .init(
                merchantId: "merchant.io.orangesys.tap-order", merchantCountryCode: "JP"
            )
            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
            // methods that complete payment after a delay, like SEPA Debit and Sofort.
            configuration.allowsDelayedPaymentMethods = true

            DispatchQueue.main.async {
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
                // Present Apple Pay payment sheet
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let rootViewController = windowScene.keyWindow?.rootViewController else { return }
                self.paymentSheet?.present(from: rootViewController, completion: { result in
                    switch result {
                    case .completed:
                        self.doSomething()
                    case .canceled:
                        break
                    case .failed(let error):
                        print(error)
                    }
                    self.paying = false
                })
            }
        }.store(in: &self.cancellables)
    }

    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
    }
    #endif
    func callApplePay() {
        let total = needPayValue()
        guard total > 0, paying == false else {
            doSomething()
            return
        }
        
        self.paying = true
        self.paymentHandler.startPayment(amount: total, completion: { success in
            self.paying = false
            if success {
                self.doSomething()
                print("Success")
            } else {
                print("Failed")
            }
        })
    }
    
    private func needPayValue() -> Int {
        guard !myAddToCart.isEmpty else {
            return 0
        }
        
        return myAddToCart.reduce(0) { partialResult, item in
            partialResult + item.count * item.foodPrice
        }
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
            let response = try JSONDecoder().decode(CartResponse.self, from: data)
            let allItems = response.items.map({$0.value})
            let myUserId = UserViewModel.shared.userid
           
            let groupUserDic = Dictionary(grouping: allItems) {$0.userId}
            self.myAddToCart = groupUserDic["\(myUserId)"] ?? []
            self.newCartList = myAddToCart + groupUserDic.flatMap({$0.value})

            let numberString = "\(response.items.count)"
            self.numbelString = String(format: "N items in cart".localizedString, numberString)
            self.badgeNum = response.items.count
            self.totalStr = "\(response.total)"
        } catch {
            print(error)
        }
    }
}
