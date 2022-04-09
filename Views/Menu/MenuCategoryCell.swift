//
//  MenuCategoryCell.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import Kingfisher
import SwiftUI

struct MenuCategoryCell: View {
    var imgName = "bugger"
    var catName = "bugger"
    var isSelected = false

    var item: NewFoodsCat
    @Binding var selItemId: String

    var body: some View {
        VStack {
            Button {
                selItemId = item.id
            } label: {
                KFImage.url(URL(string: item.image!))
                    .resizable()
                    .frame(width: .MenuCatgoryWidth, height: .MenuCatgoryWidth)
                    .scaledToFit()
                    // .padding(3)
                    .background(item.id == selItemId ? Color.themeColor : Color.normalGray)
                    .cornerRadius(20)
            }
            Text(item.name)
                .font(.system(size: 17))
                .foregroundColor(.themeColor)
        }
        .frame(width: .MenuCatgoryWidth)
    }
}

// struct MenuCategoryCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuCategoryCell()
//    }
// }
