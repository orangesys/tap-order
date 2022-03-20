//
//  TapOrderClipApp.swift
//  TapOrderClip
//
//  Created by solo on 2022/2/26.
//

import SwiftUI
import Combine

@main
struct TapOrderClipApp: App {
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
