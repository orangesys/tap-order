//
//  CartViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/24/22.
//

import Combine
import Network
import PassKit
import Stripe
import SwiftUI

enum InCartAction {
    case remove
    case plusOne
    case subtractOne
}

class CartViewModel: ObservableObject, APIService {
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?

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

    var sendEnable: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(self.newCartListEmpty, self.isPaying)
            .map { value2, value1 in
                value2 || value1
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
        self.paymentHandler.startPayment { success in
            if success {
                print("Success")
            } else {
                print("Failed")
            }
        }
    }

    func preparePaymentSheet() {
        guard let total = Int(totalStr), total > 0, paying == false else {
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

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {
    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .masterCard,
        .visa,
    ]

    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?

    func startPayment(completion: @escaping PaymentCompletionHandler) {
        let merchantIdentifier = "merchant.io.orangesys.tap-order"
        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "JP", currency: "JPY")
        StripeAPI.jcbPaymentNetworkSupported = true
        // Configure the line items on the payment request
        paymentRequest.paymentSummaryItems = [
            // The final line should represent your company;
            // it'll be prepended with the word "Pay" (that is, "Pay iHats, Inc $50")
            PKPaymentSummaryItem(label: "OrangeSys, Inc.", amount: 123.00),
        ]
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks

        // Initialize an STPApplePayContext instance

//    if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
//        // Present Apple Pay payment sheet
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.keyWindow else { return }
//        applePayContext.presentApplePay(from: window) {
//
//        }
//    } else {
//        // There is a problem with your Apple Pay configuration
//    }
        self.completionHandler = completion

//     Create our payment request
//    let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = self.paymentSummaryItems
        paymentRequest.merchantIdentifier = merchantIdentifier
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "ZH"
        paymentRequest.currencyCode = "CNY"
        paymentRequest.requiredShippingContactFields = [.phoneNumber, .emailAddress]
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks

//     Display our payment request
        self.paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        self.paymentController?.delegate = self
        self.paymentController?.present(completion: { (presented: Bool) in
            if presented {
                NSLog("Presented payment controller")
            } else {
                NSLog("Failed to present payment controller")
                self.completionHandler!(false)
            }
        })
    }
}

extension PaymentHandler: ApplePayContextDelegate {
    func applePayContext(
        _ context: STPApplePayContext,
        didCreatePaymentMethod paymentMethod: StripeAPI.PaymentMethod,
        paymentInformation: PKPayment,
        completion: @escaping STPIntentClientSecretCompletionBlock
    ) {}

    func applePayContext(
        _ context: STPApplePayContext,
        didCompleteWith status: STPApplePayContext.PaymentStatus,
        error: Error?
    ) {}
}

/*
 PKPaymentAuthorizationControllerDelegate conformance.
 */
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        // Perform some very basic validation on the provided contact information
        if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
            self.paymentStatus = .failure
        } else {
            // Here you would send the payment token to your server or payment provider to process
            // Once processed, return an appropriate status in the completion handler (success, failure, etc)
            self.paymentStatus = .success
        }

        completion(self.paymentStatus)
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
}
