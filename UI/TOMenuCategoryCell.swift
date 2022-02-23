//
//  TOMenuCategoryCell.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct TOMenuCategoryCell: View {
    private var colors: [Color] = [.yellow, .purple, .green]
    var imgName = "bugger"
    var catName = "bugger"
    var isSelected = false

    var body: some View {
        
        VStack {
            Image(imgName)
                .resizable()
                .font(.system(size: 30))
                .frame(width: .TOMenuCatgoryWidth , height: .TOMenuCatgoryWidth )
                .scaledToFit()
                .padding(3)
                .background(isSelected ? Color.themeColor : Color.normalGray)
            .cornerRadius(20)
            Text(catName)
                .font(.system(size: 17))
                .foregroundColor(.themeColor)
        }
    }
}

struct TOMenuCategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        TOMenuCategoryCell()
    }
}
