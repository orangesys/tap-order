//
//  TOOrderCell.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI
import Kingfisher

struct TOOrderListCell: View {
    var item:TOCartItem
    
    var body: some View {
        HStack {
            KFImage(URL(string:"\(item.foodPic)"))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 130, alignment: .center)
                .background(Color.normalGray)
                .cornerRadius(20)
            VStack(alignment:.leading,spacing: 15){
                HStack {
                    Text(item.foodName)
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                }
                Text("\(item.foodPrice)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.normalYellow)
                HStack {
                    Text("\(item.count)")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.themeColor)
                }
            }
        }
    }
}

struct TOOrderListCell_Previews: PreviewProvider {
    static var previews: some View {
        TOOrderListCell(item: TOCartItem(foodName: "food", foodId: "12", foodPrice: 12, foodPic: "image", userId: "12", count: 2, sid: "12"))
    }
}
