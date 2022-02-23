//
//  TapOrderApp.swift
//  Shared
//
//  Created by solo on 2/21/22.
//

import SwiftUI
import Firebase

@main
struct TapOrderApp: App {
    
    init() {
      FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
