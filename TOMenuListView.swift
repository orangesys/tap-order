//
//  TOMenuListView.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct TOMenuListView: View {
    let myList: [String] = ["1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3"]
    let headerHeight = CGFloat(120)
    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]
    private var oneColumnGrid = [GridItem(.flexible())]
    private var twoColumnGrid = [GridItem(.flexible()),GridItem(.flexible())]
    private var colors: [Color] = [.yellow, .purple, .green]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: oneColumnGrid) {
                        // Display the item
                        ForEach((0...10), id: \.self) {_ in
                            TOMenuCategoryCell()
//                            Image(systemName: symbols[$0 % symbols.count])
//                                .font(.system(size: 30))
//                                .frame(width: 60, height: 60)
//                                .padding(10)
//                                .background(colors[$0 % colors.count])
//                                .cornerRadius(10)
                        }
                    }
                }
                .zIndex(1)
                .frame(height: headerHeight)
                .padding(20)
                .background(.white)
                
                ScrollView(.vertical) {
                    Color.purple
                        .frame(height: headerHeight + 40)
                    LazyVGrid(columns: twoColumnGrid,spacing: 40) {
                        // Display the item
                        ForEach((0...10), id: \.self) {_ in
                            TOMenuListCell()
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .navigationTitle("Menu")
                .toolbar {
                    Text("no.0001")
                }
            }
        }
    }
    
    struct TOMenuListView_Previews: PreviewProvider {
        static var previews: some View {
            TOMenuListView()
        }
    }
}
