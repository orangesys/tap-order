//
//  OrderCell.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI
import Kingfisher

struct OrderListCell: View {
    var item:CartItem
    
    var body: some View {
        HStack {
            KFImage(URL(string:"\(item.foodPic)"))
                .resizable()
                .scaledToFit()
            VStack(alignment:.leading,spacing: 12){
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

struct OrderListCell_Previews: PreviewProvider {
    static var previews: some View {
        OrderListCell(item: CartItem(foodName: "food", foodId: "12", foodPrice: 12, foodPic: "image", userId: "12", count: 2, sid: "12"))
    }
}
