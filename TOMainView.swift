//
//  TOMainView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI

struct TOMainView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.themeColor.opacity(0.4))
    }
    var body: some View {
        TabView {
            // menu
            NavigationView{
                TOMenuListView()
                //.navigationBarTitle("Menu", displayMode: .large)  // << !!
                    .navigationTitle("Menu")
                    .toolbar {
                        Text("no.0001")
                    }
            }
            .tabItem {
                Image(systemName: "house.fill")
                    .foregroundColor(Color.themeColor)
            }
            // cart
            NavigationView{
                TOCartView()
                .navigationBarTitle("2 items in cart", displayMode: .large) // << !!
            }
            .tabItem {
                Image(systemName: "cart.fill")
            }.badge(2)
            // order list
            NavigationView{
                TOOrderListView()
                    .navigationBarTitle("Order list", displayMode: .large) // << !!
            }
            .tabItem {
                Image(systemName: "person.fill")
            }
        }
        .accentColor(.themeColor)
    }
}

struct TOMainView_Previews: PreviewProvider {
    static var previews: some View {
        TOMainView()
    }
}
