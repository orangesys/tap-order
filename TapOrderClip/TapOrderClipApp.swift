//
//  TapOrderClipApp.swift
//  TapOrderClip
//
//  Created by solo on 2022/2/26.
//

import SwiftUI

@main
struct TapOrderClipApp: App {
    @ObservedObject var contentViewModel = ContentViewModel.shared
    init() {
      
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(rootPage: $contentViewModel.rootPage)
        }
    }
}
