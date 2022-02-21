//
//  ContentView.swift
//  Shared
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct ContentView: View {
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
                                Text("Hello, world!").font(.toOrderFont)
                            }//.offset(x:0, y: 60)
                        ,alignment: .center)
                    Spacer()
                    Text("weather Joing  the exist order")
                        .font(.system(size: 27, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    Button(action: {
                        print("sign up bin tapped")
                    }) {
                        Text("Get Started")
                            .frame(minWidth: 220)
                            .font(.system(size: 24, weight: .semibold))
                            .padding()
                            .foregroundColor(Color(uiColor: UIColor(rgb: 0x6644ab)))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 0)
                        )
                    }
                    .background(Color.white.opacity(0.85)) // If you have this
                    .cornerRadius(25)
                    Spacer()
                }
                ,alignment: .top)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
