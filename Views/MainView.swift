//
//  MainView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import PopupView
import SwiftUI

private enum AtionType {
    case aboutus
    case policy
    case connectus
}

struct MainView: View {
    @State private var showWebView = false
    @State private var showingOptions = false
    @State private var actionType: AtionType = .aboutus {
        didSet {
            showWebView.toggle()
        }
    }
    
    @StateObject var userSetting = UserViewModel.shared
    @StateObject var globalCartList = CartViewModel(urlstr: String.urlStr(req: .cart))
    @State var isSwitchLan = UserViewModel.shared.didChangeLan
    @State var lanDidChange = false
    @State var selectedLan: Language? = .en
    // let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = appearance
        // Use this if NavigationBarTitle is with Large Font
        // set large title padding
        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        style.firstLineHeadIndent = 20
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 36, weight: .medium), .paragraphStyle: style]
    }
    
//    let stream = WebSocketStream(url: "ws://localhost:8080/api/v1/shops/e988662acc1fe9b08a9e764bacfcb304/tables/A2/carts?language=ja")
    
    var body: some View {
        Self._printChanges()
        return ZStack {
            if isSwitchLan {
                LanguageListView(isSwitch: $isSwitchLan, seledLan: $selectedLan, lanDidchange: $lanDidChange)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: 0.3)
                    .zIndex(1)
                    .environmentObject(userSetting)
            }
            TabView {
                // menu
                NavigationView {
                    MenuListView(isSwitch: $lanDidChange)
                        // .navigationBarTitle("Menu", displayMode: .large)  // << !!
                        .navigationTitle("Menu".localizedString)
                        .toolbar {
                            LanguageButtonView(isSwitch: $isSwitchLan, seledLan: $selectedLan)
                        }
                }
                .tabItem {
                    Image(systemName: "house.fill")
                        .foregroundColor(Color.themeColor)
                }
                // cart
                NavigationView {
                    CartView()
                        .navigationBarTitle(globalCartList.numbelString, displayMode: .large) // << !!
                }
                .tabItem {
                    Image(systemName: "cart.fill")
                }.badge(globalCartList.badgeNum)
                // order list
                NavigationView {
                    OrderListView(lanChange: $lanDidChange)
                        .navigationBarItems(leading: Button {} label: {},
                                            trailing: Button {
                                                showingOptions.toggle()
                                            } label: {
                                                Image(systemName: "info.circle")
                                            })
                        .navigationBarTitle("Order list".localizedString, displayMode: .large) // << !!
                }.sheet(isPresented: $showWebView) {
                    switch self.actionType {
                    case .aboutus:
                        WebView(url: URL(string: "https://orangesys.io/law")!)
                    case .policy:
                        WebView(url: URL(string: "https://tap-order-website.orangesys.io/policy/")!)
                    case .connectus:
                        WebView(url: URL(string: "https://tap-order-website.orangesys.io/support/")!)
                    }
                }.confirmationDialog("Info", isPresented: $showingOptions, titleVisibility: .visible) {
                    Button("About Us") {
                        self.actionType = .aboutus
                    }

                    Button("Policy") {
                        self.actionType = .policy
                    }

                    Button("Connect Us") {
                        self.actionType = .connectus
                    }
                }
                .tabItem {
                    Image(systemName: "person.fill")
                }
            }
            .accentColor(.themeColor)
            .environmentObject(globalCartList)
            .environmentObject(userSetting)
            .popup(isPresented: $globalCartList.isError, type: .floater(verticalPadding: .TopSafePadding), position: .top, autohideIn: 2) {
                ToastView(content: self.globalCartList.errorStr)
            }
            .overlay(
                LoadingView()
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
