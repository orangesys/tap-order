//
//  PaymentHandler.swift
//  TapOrderClip
//
//  Created by Felix Yuan on 2022/4/9.
//

import StripeApplePay
import StripeCore
import PassKit


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

    func startPayment(amount: Int, completion: @escaping PaymentCompletionHandler) {
        let merchantIdentifier = "merchant.io.orangesys.tap-order"
        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "JP", currency: "JPY")
        StripeAPI.jcbPaymentNetworkSupported = true
        // Configure the line items on the payment request
        paymentRequest.paymentSummaryItems = [
            // The final line should represent your company;
            // it'll be prepended with the word "Pay" (that is, "Pay iHats, Inc $50")
            PKPaymentSummaryItem(label: "OrangeSys, Inc.", amount: NSDecimalNumber(value: amount)),
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

