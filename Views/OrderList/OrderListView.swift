//
//  OrderListView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI

struct OrderListView: View {
    let dataList = [1,2,3,1,2,3]
    
    @StateObject var orderVM = OrderViewModel(urlstr: String.urlStr(req: .order))
    @Binding var lanDidChange:Bool
    
    init(lanChange:Binding<Bool>) {
        self._lanDidChange = lanChange
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        //NavigationView {
        
        VStack {
            List {
                ForEach(orderVM.newOrderList, id:\.sid) { one in
                    OrderListCell(item: one)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            
            ZStack(alignment: .bottom) {
                HStack {
                    Text("Total:")
                        .font(.system(size: 22, weight: .semibold))
                    Spacer()
                    Text("\(self.orderVM.totalStr)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.normalYellow)
                }
                .background(.white)
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
        }
        .padding(EdgeInsets(top: 0, leading: .menuListPadding, bottom: 0, trailing: .menuListPadding))
        .onChange(of: self.lanDidChange) { newValue in
            if newValue {
                orderVM.socket?.disconnect()
            }
        }
        
    }
    
    private func doSomething(content:String) {
        
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView(lanChange: .constant(false))
    }
}
