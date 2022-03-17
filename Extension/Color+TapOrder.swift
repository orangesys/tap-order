//
//  Color+TapOrder.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/17.
//

import UIKit
import SwiftUI

extension Font {
    static var  toOrderFont: Font {
        return .system(size: 20, weight: .bold)
    }
}

extension Color {
    static var themeColor: Color {
        return Color(uiColor: UIColor(rgb: 0x6644AB))
    }
    static var normalGray: Color {
        return Color(uiColor: UIColor(rgb: 0xeeeeee))
    }
    static var normalGreen: Color {
        return Color(uiColor: UIColor(rgb: 0x18794B))
    }
    static var normalYellow: Color {
        return Color(uiColor: UIColor(rgb: 0xDCB21C))
    }
    static var normalRed: Color {
        return Color(uiColor: UIColor(rgb: 0xBD2727))
    }
    static var toastRed: Color {
        return Color(uiColor: UIColor(rgb: 0xDA615C))
    }
}
