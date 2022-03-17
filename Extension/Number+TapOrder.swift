//
//  Number+TapOrder.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/17.
//

import UIKit

extension CGFloat {
    static let menuListPadding = CGFloat(35)
    static let menuListCatgoryPadding = CGFloat(14)
    
    static var menuListContent: CGFloat {
        return SCREENWIDTH - menuListPadding * 2
    }
    static var SCREENWIDTH: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var MenuCardWidth: CGFloat {
        return (( SCREENWIDTH - menuListPadding * 3 ) * 0.5)
    }
    static var MenuCatgoryWidth: CGFloat {
        return ((SCREENWIDTH - menuListPadding * 2 - menuListCatgoryPadding * 3) / 4)
    }
    static var TopSafePadding: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        return window?.safeAreaInsets.top ?? 44.0
    }
}

extension Double {
    func round2Str() -> String {
        return String(format: "%.2f", self)
    }
}
    


