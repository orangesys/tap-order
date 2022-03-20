//
//  ContentView.swift
//  Shared
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var rootPage: RootPage
    var body: some View {
        if self.rootPage == .start {
            StartView()
        } else {
            MainView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(rootPage: Binding.constant(.start))
    }
}
