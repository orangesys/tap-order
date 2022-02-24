//
//  TOTestView.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/24/22.
//

import SwiftUI

struct TOTestView: View {
    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]
    private var colors: [Color] = [.yellow, .purple, .green]

//    private var gridItemLayout = [GridItem(.fixed(10), spacing: 100)]//, GridItem(.adaptive(minimum: 50))]
    private var gridItemLayout = [GridItem(.flexible())]//[GridItem(.fixed(150))]//, GridItem(.adaptive(minimum: 50))]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: gridItemLayout, spacing: 30) {
                ForEach((0...40), id: \.self) {
                    Image(systemName: symbols[$0 % symbols.count])
                        .font(.system(size: 30))
                        .frame(width:50, height: 50)
                        .background(colors[$0 % colors.count])
                        .cornerRadius(10)
                }
            }
        }.frame(
            height:110
        )
    }
}

struct TOTestView_Previews: PreviewProvider {
    static var previews: some View {
        TOTestView()
    }
}
