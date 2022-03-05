//
//  TOUserViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/25/22.
//

import Foundation
import Combine
import SwiftUI

class TOUserViewModel: ObservableObject {
    static let shared = TOUserViewModel()
    let userid = UUID().uuidString
    
    @Published var lang: String = "en"

        var bundle: Bundle? {
            let b = Bundle.main.path(forResource: lang, ofType: "lproj")!
            return Bundle(path: b)
        }
}

extension Bundle {
    func localizedString(forKey key: String) -> String {
      self.localizedString(forKey: key, value: nil, table: nil)
  }
}
extension String {
    var localizedString: String {
        TOUserViewModel.shared.bundle!.localizedString(forKey: self)
    }
}
