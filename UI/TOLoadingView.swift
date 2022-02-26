//
//  TOLoadingView.swift
//  TapOrder
//
//  Created by solo on 2022/2/26.
//

import SwiftUI

struct TOLoadingView: View {
    var body: some View {
        ProgressView()
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 20)
    }
}

struct TOLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        TOLoadingView()
    }
}
