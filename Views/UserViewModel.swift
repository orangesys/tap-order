//
//  UserViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/25/22.
//

import Foundation
import Combine
import SwiftUI

class UserViewModel: ObservableObject {
    static let shared = UserViewModel()
    var userid = UUID().uuidString
    
    @State var didChangeLan: Bool = false
    @Published var lang: String = "en" { // en ja zh
        didSet {
            self.didChangeLan = true
        }
    }
    
    var bundle: Bundle? {
        let b = Bundle.main.path(forResource: lang, ofType: "lproj")!
        return Bundle(path: b)
    }
}

extension String {
    var localizedString: String {
        UserViewModel.shared.bundle!.localizedString(forKey: self)
    }
}
