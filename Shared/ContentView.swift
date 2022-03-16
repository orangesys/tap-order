//
//  ContentView.swift
//  Shared
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ContentViewModel.shared
    var body: some View {
        if viewModel.rootPage == .start {
            TOStartView()
        } else {
            TOMainView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
