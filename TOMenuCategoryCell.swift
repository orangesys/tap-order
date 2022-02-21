//
//  TOMenuCategoryCell.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct TOMenuCategoryCell: View {
    private var colors: [Color] = [.yellow, .purple, .green]
    var imgName = "keyboard"
    var catName = "keyboard"
    var isSelected = false

    var body: some View {
        
        VStack {
            Image(systemName: imgName)
                .font(.system(size: 30))
                .frame(width: 60, height: 60)
                .scaledToFit()
                .padding(10)
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
