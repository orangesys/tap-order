//
//  TOToastView.swift
//  TapOrder
//
//  Created by solo on 2022/2/25.
//

import SwiftUI

struct TOToastView: View {
    var content: String = "something is wrong"
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color.white)
                .font(.system(size: 30))
                .padding()
            Text("\(content)")
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .foregroundColor(.white)
                .padding(5)
        }
        .frame(width: .menuListContent, height: 60, alignment: .center)
        .background(Color.toastRed)
        .cornerRadius(30)
    }
}

struct TOToastView_Previews: PreviewProvider {
    static var previews: some View {
        TOToastView()
    }
}
