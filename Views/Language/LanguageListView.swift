//
//  LanguageListView.swift
//  TapOrder
//
//  Created by solo on 2022/3/3.
//

import SwiftUI

struct Language: Identifiable {
    static let zh: Language = Language(flag: "π¨π³", displayName: "δΈ­ζ")
    static let ja: Language = Language(flag: "π―π΅", displayName: "ζ₯ζ¬θͺ")
    static let en: Language = Language(flag: "πΊπΈ", displayName: "English")
    
    var id = UUID()
    var flag: String
    var displayName: String
}

struct LanguageListView: View {
    let rows: [Language] = [.ja, .en, .zh]
    
    @Binding var isSwitch:Bool
    @Binding var seledLan:Language?
    @Binding var lanDidchange:Bool
    
    var body: some View {
        //ScrollView(.vertical, showsIndicators: false) {
        
        //δΉεθΏιεηθζ―δ½ζ―ζ²‘ζεε¨ζεη¦»
        //VStack {
            VStack {
                Text("Switching Language")
                    .font(.system(size: 17))
                    .foregroundColor(.themeColor)
                    .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
                List {
                    ForEach(rows) { one in
                        LanguageCell(item: one, seledItem: $seledLan, isSwitch: $isSwitch, lanDidchange: $lanDidchange)
                            .listRowSeparator(.hidden)
                            .padding([.leading, .trailing])
                    }
                }
                .listStyle(.plain)
                .background(.white)
                .padding()
            }
            //.padding([.leading,.trailing], 20)
            .background(.white)
            .frame(width:.SCREENWIDTH-100, height: 238)
            .cornerRadius(40)
        }
//        .padding()
//        .frame(maxWidth:.infinity, maxHeight: .infinity)
//        .ignoresSafeArea(.all)
//        .background(.ultraThinMaterial)
//    }
}

struct LanguageListView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageListView(isSwitch: .constant(false),
                         seledLan: .constant(.ja),
                         lanDidchange: .constant(false))
    }
}
