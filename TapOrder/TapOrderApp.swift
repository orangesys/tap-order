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
    var cancleAble: Cancellable?
    init() {
      
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(rootPage: $contentViewModel.rootPage)
        }
    }
}
