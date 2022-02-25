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
}
