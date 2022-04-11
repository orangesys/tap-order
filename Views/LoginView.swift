//
//  LoginView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import AuthenticationServices
import Combine
import SwiftUI
import WebKit

struct LoginView: View {
    var loginViewModel = LoginViewModel()
    @State private var showWebView = false
    @State private var showWebView2 = false
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(rgb: 0x412F96)), Color(uiColor:UIColor(rgb: 0x944AB5).withAlphaComponent(0.85))]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea(.all) // Ignore just for the color
            .overlay(
                VStack {
                    Spacer()
                    Circle()
                        .fill(Color.white)
                        .frame(width: 280, height: 280)
                    //.offset(x:0,y: 100)
                        .overlay(
                            VStack(spacing:5) {
                                Image("chicken")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 150)
                                Text("No.#00001").font(.toOrderFont)
                            }//.offset(x:0, y: 60)
                            ,alignment: .center)
                    Spacer()
                    Text("weather Joing  the exist order")
                        .font(.system(size: 27, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    
                    #if DEBUG
                    Button(action: {
                        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
                            window.rootViewController = UIHostingController(rootView: MainView())
                            window.makeKeyAndVisible()
                        }
                    }) {
                        Text("Get Started")
                            .frame(minWidth: 220)
                            .font(.system(size: 24, weight: .semibold))
                            .padding()
                            .foregroundColor(Color(uiColor: UIColor(rgb: 0x6644ab)))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.red, lineWidth: 0)
                            )
                    }
                    .background(Color.white.opacity(0.85)) // If you have this
                    .cornerRadius(25)
                    #endif
                    
                    QuickSignInWithApple()
                        .frame(width: 250, height: 60, alignment: .center)
                        .onTapGesture(perform: signInWithApple)
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showWebView.toggle()
                        } label: {
                            Text("Items of Use").font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(uiColor: UIColor.systemYellow.withAlphaComponent(0.8))).overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.yellow),
                                    alignment: .bottom
                            )
                        }
                        .sheet(isPresented: $showWebView) {
                            WebView(url:  URL(string: "https://tap-order-website.orangesys.io/policy/")!)
                        }
                        
                        Spacer()
                        
                        Button {
                            showWebView2.toggle()
                        } label: {
                            Text("Business Cooperation").font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(uiColor: UIColor.systemYellow.withAlphaComponent(0.8))).overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.yellow),
                                    alignment: .bottom
                            )
                        }
                        .sheet(isPresented: $showWebView2) {
                            WebView(url:  URL(string: "https://tap-order-website.orangesys.io/business/")!)
                        }
                        Spacer()
                    }
                   
                    Spacer()
                }
                ,alignment: .top)
        
    }
    
    private func signInWithApple() {
        loginViewModel.signInWithApple()
     }
}


struct WebView: UIViewRepresentable {
    var url: URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

fileprivate struct QuickSignInWithApple: UIViewRepresentable {
    typealias UIViewType = ASAuthorizationAppleIDButton
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let bt = ASAuthorizationAppleIDButton(type:.signIn, style: .white)
        bt.cornerRadius = 30
        return bt
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}


struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
