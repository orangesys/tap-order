//
//  TOMenuListView.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct TOMenuListView: View {
    let myList: [String] = ["1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3"]
    let headerHeight = CGFloat(150)
    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]
    private var oneColumnGrid = [GridItem(.flexible())]
    private var twoColumnGrid = [GridItem(.flexible(),spacing: .menuListPadding),GridItem(.flexible(),spacing: .menuListPadding)]
    private var colors: [Color] = [.yellow, .purple, .green]
    
    init() {
            //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont.systemFont(ofSize: 36)]

            //Use this if NavigationBarTitle is with displayMode = .inline
            //UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
        }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: twoColumnGrid,spacing: 40,pinnedViews: [.sectionHeaders]) {
                    Section {
                        // Display the item
                        ForEach((0...10), id: \.self) {_ in
                            TOMenuListCell()
                        }
                    } header: {
                        VStack(alignment:.leading) {
                            ScrollView(.horizontal) {
                                LazyHGrid(rows: oneColumnGrid) {
                                    // Display the item
                                    ForEach((0...10), id: \.self) {_ in
                                        TOMenuCategoryCell()
                                    }
                                }
                            }
                            .frame(height: 110)
                            Text("Food List")
                                .font(.system(size: 24))
                                .frame(height: 40)
                        }
                        .frame(height: headerHeight)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                        .background(.white)
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
            .navigationTitle("Menu")
            .toolbar {
                Text("no.0001")
            }
            
        }
    }
    
    struct TOMenuListView_Previews: PreviewProvider {
        static var previews: some View {
            TOMenuListView()
        }
    }
}
