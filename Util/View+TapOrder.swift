//
//  View+TapOrder.swift
//  TapOrder
//
//  Created by Felix Yuan on 2022/3/17.
//

import SwiftUI

extension View {
    func sbadge(count: Int) -> some View {
        overlay(
            ZStack {
                if count != 0 {
                    Circle()
                        .fill(Color.red)
                    Text("\(count)")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
            .offset(x: 12, y: -12)
            .frame(width: 24, height: 24)
        , alignment: .topTrailing)
    }
}
