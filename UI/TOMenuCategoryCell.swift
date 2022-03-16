//
//  TOMenuCategoryCell.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI
import Kingfisher

struct TOMenuCategoryCell: View {
    var imgName = "bugger"
    var catName = "bugger"
    var isSelected = false
    
    var item: TONewFoodsCat
    @Binding var selItemId: String

    var body: some View {
        
        VStack {
            Button {
                selItemId = item.id!
            } label: {
                KFImage.url(URL(string: item.image!))
                    .resizable()
                    .frame(width: .TOMenuCatgoryWidth, height: .TOMenuCatgoryWidth)
                    .scaledToFit()
                    //.padding(3)
                    .background(item.id! == selItemId ? Color.themeColor : Color.normalGray)
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
