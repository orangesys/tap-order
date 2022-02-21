//
//  TOMenuListView.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct TOMenuListView: View {
    let myList: [String] = ["1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3"]
    let headerHeight = CGFloat(50)
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
                        ForEach((0...10), id: \.self) {
                            Image(systemName: symbols[$0 % symbols.count])
                                .font(.system(size: 30))
                                .frame(width: 60, height: 60)
                                .padding(10)
                                .background(colors[$0 % colors.count])
                                .cornerRadius(10)
                        }
                    }
                }
                .zIndex(1)
                .frame(height: headerHeight)
                .background(.white)
                
                ScrollView(.vertical) {
                    Color.clear
                        .frame(height: headerHeight)
                    LazyVGrid(columns: twoColumnGrid) {
                        // Display the item
                        ForEach((0...10), id: \.self) {
                            Image(systemName: symbols[$0 % symbols.count])
                                .font(.system(size: 30))
                                .frame(width: 154, height: 214)
                                .background(colors[$0 % colors.count])
                                .cornerRadius(10)
                        }
                    }
                }
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
