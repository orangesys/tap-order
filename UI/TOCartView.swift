//
//  TOCartView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI

struct TOCartView: View {
    let dataList = [1,2,3]
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    @EnvironmentObject var globalCart: TOCartViewModel
    
    var body: some View {
        //NavigationView {
        
        VStack {
            List {
                ForEach(self.globalCart.cartList, id:\.first!.delId) { one in
                    TOCartCell(model: one)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            
            ZStack(alignment: .bottom) {
                VStack(spacing:.menuListPadding) {
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
                            .foregroundColor(.themeColor)
                            .overlay(alignment: .center) {
                                Text("Send order")
                                    .font(.system(size: 24,weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width:.SCREENWIDTH - 80,height: 64)
                    }
                }
                .background(.white)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            }
        }
        .padding(EdgeInsets(top: 0, leading: .menuListPadding, bottom: 0, trailing: .menuListPadding))
        
    }
    
    private func doSomething() {
        
    }
}

struct TOCartView_Previews: PreviewProvider {
    static var previews: some View {
        TOCartView()
    }
}
