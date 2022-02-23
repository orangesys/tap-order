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
    
    var item: TOFoodsCatItem
    @Binding var selItemId: Int

    var body: some View {
        
        VStack {
            Button {
                selItemId = item.catgoryId
            } label: {
                Image(imgName)
                    .resizable()
                    .frame(width: .TOMenuCatgoryWidth , height: .TOMenuCatgoryWidth )
                    .scaledToFit()
                    .padding(3)
                    .background(item.catgoryId == selItemId ? Color.themeColor : Color.normalGray)
                .cornerRadius(20)
            }
            Text(item.catgoryName)
                .font(.system(size: 17))
                .foregroundColor(.themeColor)
        }
    }
}

//struct TOMenuCategoryCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TOMenuCategoryCell()
//    }
//}
