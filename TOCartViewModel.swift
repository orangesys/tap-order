//
//  TOCartViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/24/22.
//

import Foundation
import Combine
import SwiftUI

class TOCartViewModel: ObservableObject {
    @Published var cartList = [TOFoodsItem]()
}
