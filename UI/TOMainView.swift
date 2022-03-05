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
    @StateObject var userSetting = TOUserViewModel.shared
    @State var isSwitchLan = false
    @State var selectedLan:TOLanguage? = TOLanguage(name: "Japan", flagName: "🇯🇵")
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
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
    
    private let stream = WebSocketStream(url: "ws://192.168.0.106:8080")
    
    var body: some View {
        ZStack {
            if isSwitchLan {
                TOLanguageListView(isSwitch: $isSwitchLan, seledLan: $selectedLan)
                    .transition(.move(edge: .bottom))
                    //.animation(.spring(), value: 0.3)
                    .zIndex(1)
                    .environmentObject(userSetting)
            }
            TabView {
                // menu
                NavigationView{
                    TOMenuListView()
                    //.navigationBarTitle("Menu", displayMode: .large)  // << !!
                        .navigationTitle("Menu")
                        .toolbar {
                            TOLanguageButtonView(isSwitch: $isSwitchLan)
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
            .environmentObject(userSetting)
            .onAppear {
                self.globalCartList.getCartList2()
            }
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
            .task {
                do {
                    for try await message in stream {
                        //                    print("\(message")
                        //                    let updateDevice = try message.device()
                        //                    devices = devices.map({ device in
                        //                        device.id == updateDevice.id ? updateDevice : device
                        //                    })
                    }
                } catch {
                    debugPrint("Oops something didn't go right")
                }
            }
        }
        //        .onReceive(timer) { time in
        //            if !self.globalCartList.isBackgroundLoading {
        //                self.globalCartList.isBackgroundLoading = true
        //                self.globalCartList.getCartList2()
        //            }
        //        }
    }
}

struct TOMainView_Previews: PreviewProvider {
    static var previews: some View {
        TOMainView()
    }
}
