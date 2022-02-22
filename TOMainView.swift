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
            NavigationView{
                TOMenuListView()
                    //.navigationBarTitle("Menu", displayMode: .large)  // << !!
                    .navigationTitle("Menu")
                    .toolbar {
                        Text("no.0001")
                    }
            }
            .tabItem {
                //VStack{
                    Image(systemName: "house.fill")
                        .foregroundColor(Color.themeColor)
                        
                        
                    //Text("Home")
                //}
            }
            
            NavigationView{
                TOMenuListView()
                    //.navigationBarTitle("Second", displayMode: .inline) // << !!
            }
            .tabItem {
                    Image(systemName: "cart.fill")
            }
            
            NavigationView{
                TOMenuListView()
                    .navigationBarTitle("Order list", displayMode: .inline) // << !!
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
