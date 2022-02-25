//
//  TOMainView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI
import PopupView

struct TOMainView: View {
    @StateObject var globalCartList = TOCartViewModel()
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.themeColor.opacity(0.4))
        //Use this if NavigationBarTitle is with Large Font
        //set large title padding
        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        style.firstLineHeadIndent = 20
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont.systemFont(ofSize: 36, weight: .medium),.paragraphStyle: style]
    }
    var body: some View {
        TabView {
            // menu
            NavigationView{
                TOMenuListView()
                //.navigationBarTitle("Menu", displayMode: .large)  // << !!
                    .navigationTitle("Menu")
                    .toolbar {
                        Text("#0001")
                            .font(.system(size: 20)).bold()
                    }
            }
            .tabItem {
                Image(systemName: "house.fill")
                    .foregroundColor(Color.themeColor)
            }
            // cart
            NavigationView{
                TOCartView()
                    .navigationBarTitle("\(globalCartList.badgeNum) items in cart", displayMode: .large) // << !!
            }
            .tabItem {
                Image(systemName: "cart.fill")
            }.badge(globalCartList.badgeNum)
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
        .environmentObject(globalCartList)
        .onAppear {
            self.globalCartList.getCartList2()
        }
        .popup(isPresented: $globalCartList.isError, type:.floater(verticalPadding: .TopSafePadding), position: .top, autohideIn: 2) {
            TOToastView(content: self.globalCartList.errorStr)
        }
    }
}

struct TOMainView_Previews: PreviewProvider {
    static var previews: some View {
        TOMainView()
    }
}
