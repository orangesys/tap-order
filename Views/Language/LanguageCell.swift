//
//  LanguageCell.swift
//  TapOrder
//
//  Created by solo on 2022/3/3.
//

import SwiftUI

struct LanguageCell: View {
    var item: Language
    @Binding var seledItem:Language?
    @Binding var isSwitch:Bool
    @EnvironmentObject var userSetting: UserViewModel
    @Binding var lanDidchange:Bool
    var body: some View {
        HStack(spacing:2) {
            VStack {
                Text(item.flag)
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                .padding([.trailing],0)
            }.frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.white)
            VStack(alignment:.leading) {
                Text(item.displayName)
                    .foregroundColor(.black)
                .font(.system(size: 20))
                .frame(width:90, alignment: .center)
            }.frame(minWidth: 90, maxWidth: .infinity)
                .background(Color.white)//blank can click
            VStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.themeColor)
                    .font(.system(size: 20))
                    .opacity(item.displayName == seledItem?.displayName ? 1 : 0)
            }.frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.white)
        }
        //.frame(minWidth: 0, maxWidth: .infinity)
        .frame(width: 200, height: 30, alignment: .leading)
        //.background(.teal)
        .onTapGesture {
            if seledItem?.id != item.id {
                lanDidchange = true
            }
            self.seledItem = item
            if item.id == Language.en.id {
                userSetting.lang = "en"
            } else if item.id == Language.ja.id {
                userSetting.lang = "ja"
            } else {
                userSetting.lang = "zh-Hant"
            }
            isSwitch.toggle()
        }
    }
}

struct LanguageCell_Previews: PreviewProvider {
    static var previews: some View {
        LanguageCell(item: .ja, seledItem: .constant(.ja),
                     isSwitch: .constant(false),
                     lanDidchange: .constant(false))
    }
}
