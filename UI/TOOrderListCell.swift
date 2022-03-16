//
//  TOOrderCell.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import Kingfisher
import SwiftUI

struct TOOrderListCell: View {
    var item: TOCartItem

    var body: some View {
        HStack {
            KFImage(URL(string: "\(item.foodPic)"))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 130, alignment: .center)
                .background(Color.normalGray)
                .cornerRadius(20).addSourceUserIcon(item.foodPic)

            VStack(alignment: .leading, spacing: 15) {
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

private extension View {
    func addSourceUserIcon(_ uid: String) -> some View {
        ZStack(alignment: .topTrailing) {
            self

            KFImage(URL(string: "\(uid)"))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .background(Color.normalGray)
                .cornerRadius(20)
                .overlay(Circle().stroke(Color.blue))
                .offset(x: 0, y: 130-32)
        }
    }
}

struct TOOrderListCell_Previews: PreviewProvider {
    static var previews: some View {
        TOOrderListCell(item: TOCartItem(foodName: "food", foodId: "12", foodPrice: 12, foodPic: "image", userId: "12", count: 2, sid: "12"))
    }
}
