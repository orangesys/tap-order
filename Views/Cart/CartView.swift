//
//  CartView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import Combine
import SwiftUI

struct CartView: View {
    let dataList = [1, 2, 3]
    @EnvironmentObject var globalCart: CartViewModel
    @State var sendButtonEnable = true

    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    var body: some View {
        VStack {
            CartListView(items: $globalCart.newCartList)
            ZStack(alignment: .bottom) {
                VStack(spacing: 20) {
                    HStack {
                        Text("Total:".localizedString)
                            .font(.system(size: 22, weight: .semibold))
                        Spacer()
                        Text(self.globalCart.totalStr)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.normalYellow)
                    }
                    #if TAPORDERCLIP
                    Button(action: self.globalCart.callApplePay) {
                        RoundedRectangle(cornerSize: CGSize(width: 25, height: 25))
                            .foregroundColor(self.globalCart.newCartList.isEmpty ? Color.gray : .themeColor)
                            .overlay(alignment: .center) {
                                Text("Send order".localizedString)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: .SCREENWIDTH - 80, height: 50)
                    }.disabled(sendButtonEnable)
                        .onReceive(globalCart.sendEnable) { result in
                            self.sendButtonEnable = result
                        }

                    #else

                    Button(action: self.globalCart.preparePaymentSheet) {
                        RoundedRectangle(cornerSize: CGSize(width: 25, height: 25))
                            .foregroundColor(self.globalCart.newCartList.isEmpty ? Color.gray : .themeColor)
                            .overlay(alignment: .center) {
                                Text("Send order".localizedString)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: .SCREENWIDTH - 80, height: 50)
                    }.disabled(sendButtonEnable)
                        .onReceive(globalCart.sendEnable) { result in
                            self.sendButtonEnable = result
                        }

                    if let result = globalCart.paymentResult {
                        switch result {
                        case .completed:
                            Text("Payment complete")
                        case .failed(let error):
                            Text("Payment failed: \(error.localizedDescription)")
                        case .canceled:
                            Text("Payment canceled.")
                        }
                    }
                    #endif
                }
                .background(.white)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            }
        }
        .padding(EdgeInsets(top: 0, leading: .menuListPadding - 15, bottom: 0, trailing: .menuListPadding - 15))
    }
}

struct CartListView: View {
    @Binding var items: [CartItem]

    var body: some View {
        List {
            ForEach(items, id: \.sid) { one in
                CartCell(item: one, delId: one.sid)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    .listRowSeparator(.hidden)
            }
        }.listStyle(.plain)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView().environmentObject(CartViewModel(urlstr: String.urlStr(req: .cart)))
    }

    func testData() -> CartViewModel {
        let item1 = CartItem(
            foodName: "牛ほほ肉の クリームミートソース",
            foodId: "-My4etMrJP5t2QuCgX9M",
            foodPrice: 1000,
            foodPic: "https://www.first-kitchen.co.jp/menuimg/5a288fcbf0328-1.png",
            userId: "MDAxMTU5Ljg0Zjg3ZGE5NDE1OTQ1NTRhOTU0ZjU1ZWNiY2U0ZGY0LjExMTc=",
            count: 1,
            sid: "1ac1355e-570c-47db-9539-024744e1d87b")
        let item2 = CartItem(
            foodName: "熟成博多明太子",
            foodId: "-My4etSWmhy3ytM7XrzE",
            foodPrice: 1250,
            foodPic: "https://www.first-kitchen.co.jp/menuimg/5a0bae5bc41b3-1.png",
            userId: "MDAxMTU5Ljg0Zjg3ZGE5NDE1OTQ1NTRhOTU0ZjU1ZWNiY2U0ZGY0LjExMTc=",
            count: 1,
            sid: "16111bd4-08ab-450d-b89b-a5502369f348")
        let item3 = CartItem(
            foodName: "Chicken Tatsuta",
            foodId: "-My4etlsx1vrx1ivM5va",
            foodPrice: 1150,
            foodPic: "https://www.first-kitchen.co.jp/menuimg/5fd14ee0883e9-1.png",
            userId: "MDAwMzkxLjFhODVkZTdmMmU1MzRjYWM5YjY0ODMyMWZhNDQ4OTk1LjExNDM=",
            count: 4,
            sid: "ac4233cb-dc78-40ed-9fad-dbcf51ca2dc2")
        let item4 = CartItem(
            foodName: "chicken nugget 10 pieces",
            foodId: "-My4eu0oromhSHo8rAUD",
            foodPrice: 1250,
            foodPic: "https://www.first-kitchen.co.jp/menuimg/61849b9d9e6b6-1.png",
            userId: "MDAwMzkxLjFhODVkZTdmMmU1MzRjYWM5YjY0ODMyMWZhNDQ4OTk1LjExNDM=",
            count: 4,
            sid: "83f8e62c-3c86-4615-a5ab-c1bcd0454508")
        let item5 = CartItem(
            foodName: "Symbiosis",
            foodId: "-My4etwIhFk3ACTon3WU",
            foodPrice: 1250,
            foodPic: "https://www.first-kitchen.co.jp/menuimg/6229368f30767-1.png",
            userId: "MDAxMTU5LmY5YzMyNDhmYzQ3ODRlMjRiMmZkZjA2ZGYzYTBjYjgyLjExNDc=",
            count: 3,
            sid: "df4b52e6-365e-4ba9-beeb-f02cdb38da6e")

        let model = CartViewModel(urlstr: String.urlStr(req: .cart))
        model.newCartList = [item1, item2, item3, item4, item5]
        return model
    }
}
