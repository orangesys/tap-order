//
//  Bundle+TapOrder.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/18.
//

import Foundation

extension Bundle {
    func localizedString(forKey key: String) -> String {
      self.localizedString(forKey: key, value: nil, table: nil)
  }
}
