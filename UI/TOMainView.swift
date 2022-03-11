//
//  TOMainView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI
import PopupView

struct TOMainView: View {
    
    @StateObject var globalCartList = TOCartViewModel(urlstr: "ws://localhost:8080/api/v1/shops/e988662acc1fe9b08a9e764bacfcb304/tables/A2/carts?language=ja")
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
    
//    let stream = WebSocketStream(url: "ws://localhost:8080/api/v1/shops/e988662acc1fe9b08a9e764bacfcb304/tables/A2/carts?language=ja")
    
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
                    TOMenuListView()
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

//            .task {
//                do {
//                    for try await message in stream {
//
//                        switch message {
//                        case .data(let data):
//                            print("Data received \(data)")
//                        case .string(let text):
//                            print("Text received \(text)")
//                            let data = text.data(using: .utf8)!
//                            do {
//                                let fjson = try JSONDecoder().decode(TOCartResponse.self, from: data)
//                                //print(fjson)
//                                //print(fjson.items.map({$0.value}))
//                                let farrJson = fjson.items.map({$0.value})
//                                let currentUser = TOUserViewModel.shared.userid
//                                var currentUserValue = [TOCartItem]()
//                                let groupUserDic = Dictionary(grouping: farrJson) {$0.userId}
//                                    .filter() {
//                                        // array first to group by dic
//                                        // and filter current user
//                                        if currentUser == $0.key {
//                                            currentUserValue = $0.value
//                                        }
//                                        return currentUser != $0.key
//                                    }
//                                //print(groupUserDic)
//                                // 排序当前用户最上面
//                                var allarr:[TOCartItem] = groupUserDic.flatMap({$0.value})
//                                allarr.insert(contentsOf: currentUserValue, at: 0)
//                                self.globalCartList.newCartList = allarr
//                                self.globalCartList.badgeNum = fjson.items.count
//                                self.globalCartList.totalStr = "\(fjson.total)"
//                            } catch {
//                                print(error)
//                            }
//                        @unknown default:
//                            fatalError("websocket panic")
//                        }
//                    }
//                } catch {
//                    debugPrint("Oops something didn't go right")
//                }
//            }
        }
    }
}

struct TOMainView_Previews: PreviewProvider {
    static var previews: some View {
        TOMainView()
    }
}
