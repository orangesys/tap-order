//
//  TOOrderListView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI

struct TOOrderListView: View {
    let dataList = [1,2,3,1,2,3]
    
    @EnvironmentObject var globalCart: TOCartViewModel
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        //NavigationView {
        
        VStack {
            List {
                ForEach(dataList, id:\.self) { _ in
                    TOOrderListCell()
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
                    Text(self.globalCart.totalStr)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.normalYellow)
                }
                .background(.white)
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
        }
        .padding(EdgeInsets(top: 0, leading: .menuListPadding, bottom: 0, trailing: .menuListPadding))
        
    }
    
    private func doSomething() {
        
    }
}

struct TOOrderListView_Previews: PreviewProvider {
    static var previews: some View {
        TOOrderListView()
    }
}
