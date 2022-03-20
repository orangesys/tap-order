//
//  TapOrderApp.swift
//  Shared
//
//  Created by solo on 2/21/22.
//

import SwiftUI
import Combine

@main
struct TapOrderApp: App {
    @ObservedObject var contentViewModel = ContentViewModel.shared
    @State var rootPage: RootPage = .start
    init() {
      
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(rootPage: $rootPage).onReceive(contentViewModel.rootPagePublisher) {
                self.rootPage = $0
            }
        }
    }
}
