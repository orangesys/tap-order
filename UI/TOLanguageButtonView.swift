//
//  TOLanguageButtonView.swift
//  TapOrder
//
//  Created by solo on 2022/3/3.
//

import SwiftUI

struct TOLanguageButtonView: View {
    @Binding var isSwitch:Bool
    @Binding var seledLan:TOLanguage?
    var body: some View {
        
//        Button(action: {
//        }) {
//            VStack(spacing: 6) {
//                HStack(spacing: 6) {
//                    Image(systemName: "globe")
//                        .foregroundColor(Color.black)
//                        .font(.system(size: 20))
//                    Text("English")
//                        .foregroundColor(Color.black)
//                        .font(.system(size: 13.0))
//                    Image(systemName: "chevron.down")
//                        .foregroundColor(Color.black)
//                        .font(.system(size: 15))
//                }
//            }
//        }
//        .buttonStyle(.bordered)
//        .controlSize(.small) // .large, .medium or .small
//        //.buttonStyle(.borderless)
//        //.padding([.leading, .trailing], 5)
        
        Button(action: {
            print(isSwitch)
            withAnimation(.spring()) {
                self.isSwitch = !self.isSwitch
            }
        }) {
            Text(seledLan!.flagName)
                .foregroundColor(Color.black)
                .font(.system(size: 20))
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
    }
}

struct TOLanguageButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TOLanguageButtonView(isSwitch: .constant(false), seledLan: .constant(TOLanguage(name: "Japan", flagName: "🇯🇵")))
    }
}
