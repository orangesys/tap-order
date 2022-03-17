//
//  LoadingView.swift
//  TapOrder
//
//  Created by solo on 2022/2/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 20)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
