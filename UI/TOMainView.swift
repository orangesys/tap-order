//
//  TOMainView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI
import PopupView

struct TOMainView: View {
    
    @StateObject var userSetting = TOUserViewModel.shared
    @StateObject var globalCartList = TOCartViewModel(urlstr: String.urlStr(req: .cart))
    @State var isSwitchLan = TOUserViewModel.shared.didChangeLan
    @State var lanDidChange = false
    @State var selectedLan:TOLanguage? = TOLanguage(name: "En", flagName: "🇺🇸")
    // let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = appearance
        //Use this if NavigationBarTitle is with Large Font
        //set large title padding
        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        style.firstLineHeadIndent = 20
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont.systemFont(ofSize: 36, weight: .medium),.paragraphStyle: style]
        
    }
    
//    let stream = WebSocketStream(url: "ws://localhost:8080/api/v1/shops/e988662acc1fe9b08a9e764bacfcb304/tables/A2/carts?language=ja")
    
    var body: some View {
        Self._printChanges()
        return ZStack {
            if isSwitchLan {
                TOLanguageListView(isSwitch: $isSwitchLan, seledLan: $selectedLan, lanDidchange:$lanDidChange)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: 0.3)
                    .zIndex(1)
                    .environmentObject(userSetting)
            }
            TabView {
                // menu
                NavigationView{
                    TOMenuListView(isSwitch: $lanDidChange)
                    //.navigationBarTitle("Menu", displayMode: .large)  // << !!
                        .navigationTitle("Menu")
                        .toolbar {
                            TOLanguageButtonView(isSwitch: $isSwitchLan, seledLan: $selectedLan)
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
                    TOOrderListView(lanChange: $lanDidChange)
                        .navigationBarTitle("Order list", displayMode: .large) // << !!
                }
                .tabItem {
                    Image(systemName: "person.fill")
                }
            }
            .accentColor(.themeColor)
            .environmentObject(globalCartList)
            .environmentObject(userSetting)
            .popup(isPresented: $globalCartList.isError, type:.floater(verticalPadding: .TopSafePadding), position: .top, autohideIn: 2) {
                TOToastView(content: self.globalCartList.errorStr)
            }
            .overlay(
                TOLoadingView()
                    .opacity(self.globalCartList.isLoading ? 1 : 0)
            )
            .overlay(
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(.black.opacity(isSwitchLan ? 0.3 : 0))
                }
            )
            .onChange(of: self.lanDidChange) { newValue in
                if newValue {
                    globalCartList.socket?.disconnect()
                }
            }
        }
    }
}

struct TOMainView_Previews: PreviewProvider {
    static var previews: some View {
        TOMainView()
    }
}
