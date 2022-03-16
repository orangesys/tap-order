//
//  TOStartView.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI
import AuthenticationServices

struct TOStartView: View {
    @State var signInWithAppleViewModel:TOSignInWithAppleVIewModel?
    
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
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: TOMainView())
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
                    
                    TOQuickSignInWithApple()
                        .frame(width: 250, height: 60, alignment: .center)
                        .onTapGesture(perform: showAppleLoginView)
                    Spacer()
                }
                ,alignment: .top)
        
    }
    
    private func showAppleLoginView() {
        signInWithAppleViewModel = TOSignInWithAppleVIewModel(window: UIApplication.shared.windows.first)
        
        // 1. Instantiate the AuthorizationAppleIDProvider
        let provider = ASAuthorizationAppleIDProvider()
        // 2. Create a request with the help of provider - ASAuthorizationAppleIDRequest
        let request = provider.createRequest()
        // 3. Scope to contact information to be requested from the user during authentication.
        request.requestedScopes = [.fullName, .email]
        // 4. A controller that manages authorization requests created by a provider.
        let controller = ASAuthorizationController(authorizationRequests: [request])
        // 5. Set delegate to perform action
        controller.delegate = signInWithAppleViewModel
        // 6. Initiate the authorization flows.
        controller.performRequests()
//        if signInWithAppleViewModel?.isSuccessLogin != .failLogin {
//            if let window = UIApplication.shared.windows.first {
//                window.rootViewController = UIHostingController(rootView: TOMainView())
//                window.makeKeyAndVisible()
//            }
//        }
     }
}

struct TOStartView_Previews: PreviewProvider {
    static var previews: some View {
        TOStartView()
    }
}
