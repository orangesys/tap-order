//
//  CartView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI

struct CartView: View {
    let dataList = [1,2,3]
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    @EnvironmentObject var globalCart: CartViewModel
    
    var body: some View {
        //NavigationView {
        
        VStack {
            List {
                ForEach(self.globalCart.newCartList, id:\.sid) { one in
                    CartCell(item: one, delId: one.sid)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            
            ZStack(alignment: .bottom) {
                VStack(spacing:20) {
                    HStack {
                        Text("Total:")
                            .font(.system(size: 22, weight: .semibold))
                        Spacer()
                        Text(self.globalCart.totalStr)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.normalYellow)
                    }
                    //Color.clear.padding(.bottom, 20)
                    Button(action: doSomething) {
                        RoundedRectangle(cornerSize: CGSize(width: 25, height: 25))
                            .foregroundColor(self.globalCart.newCartList.isEmpty ? Color.gray : .themeColor)
                            .overlay(alignment: .center) {
                                Text("Send order")
                                    .font(.system(size: 24,weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width:.SCREENWIDTH - 80,height: 50)
                    }.disabled(self.globalCart.newCartList.isEmpty)
                }
                .background(.white)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            }
        }
        .padding(EdgeInsets(top: 0, leading: .menuListPadding - 15, bottom: 0, trailing: .menuListPadding - 15))
        
    }
    
    private func doSomething() {
        let mycarts = globalCart.newCartList.filter({$0.userId == UserViewModel.shared.userid})
        globalCart.placeOrder(foods: mycarts)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
