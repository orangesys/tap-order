//
//  UITabBarController+TapOrder.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/17.
//

import UIKit

extension UITabBarController {
    open override func viewWillLayoutSubviews() {
        guard let array = self.viewControllers else {
            return
        }
        
        for controller in array {
            controller.tabBarItem.title = ""
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
        }
    }
}
