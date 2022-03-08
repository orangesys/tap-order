//
//  TOMenuCategoryCell.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct TOMenuCategoryCell: View {
    var imgName = "bugger"
    var catName = "bugger"
    var isSelected = false
    
    var item: TONewFoodsCat
    @Binding var selItemId: String

    var body: some View {
        
        VStack {
            Button {
                selItemId = item.id!.uuidString
            } label: {
                Image(imgName)
                    .resizable()
                    .frame(width: .TOMenuCatgoryWidth, height: .TOMenuCatgoryWidth)
                    .scaledToFit()
                    //.padding(3)
                    .background(item.id!.uuidString == selItemId ? Color.themeColor : Color.normalGray)
                .cornerRadius(20)
            }
            Text(item.name ?? "name")
                .font(.system(size: 17))
                .foregroundColor(.themeColor)
        }
        .frame(width:.TOMenuCatgoryWidth)
    }
}

//struct TOMenuCategoryCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TOMenuCategoryCell()
//    }
//}
