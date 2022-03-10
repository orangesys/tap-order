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
    
    let stream = WebSocketStream(url: "ws://localhost:8080/api/v1/shops/e988662acc1fe9b08a9e764bacfcb304/tables/A2/carts?language=ja")
    
    var body: some View {
        ZStack {
            if isSwitchLan {
                TOLanguageListView(isSwitch: $isSwitchLan, seledLan: $selectedLan)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: 0.3)
                    .zIndex(1)
                    .environmentObject(userSetting)
            }
            TabView {
                // menu
                NavigationView{
                    TOMenuListView(socket: stream)
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
                        switch message {
                        case .data(let data):
                            print("Data received \(data)")
                        case .string(let text):
                            print("Text received \(text)")
                            let data = text.data(using: .utf8)!
                            do {
                                let f = try JSONDecoder().decode(TOCartResponse.self, from: data)
                                // print(f)
                                self.globalCartList.newCartList = Array(f.items.values)
                                self.globalCartList.badgeNum = f.items.count
                                self.globalCartList.totalStr = "\(f.total)"
                            } catch {
                                print(error)
                            }
                        @unknown default:
                            fatalError("websocket panic")
                        }
                    }
                } catch {
                    debugPrint("Oops something didn't go right")
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
