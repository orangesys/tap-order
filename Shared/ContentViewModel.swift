//
//  ContentViewModel.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/17.
//

import Combine
import SwiftUI

enum RootPage {
    case start
    case main
}

class ContentViewModel: ObservableObject {
    static let shared = ContentViewModel()

    @Published var rootPage = SignInWithApple.didExitUser() ? RootPage.main : RootPage.start
    private init() {
         
    }
}
