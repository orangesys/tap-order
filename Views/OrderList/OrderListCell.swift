//
//  OrderCell.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import Kingfisher
import LetterAvatarKit
import SwiftUI

struct OrderListCell: View {
    var item:CartItem
    
    var body: some View {
        HStack {
            KFImage(URL(string:"\(item.foodPic)"))
                .resizable()
                .scaledToFit()
                .addSourceUserIcon(item.foodPic)
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

private extension View {
    private func userAvatar() -> UIImage {
        let circleAvatarImage = LetterAvatarMaker()
                .setCircle(true)
                .setUsername(SignInWithApple.randomNickname())
                .setBorderWidth(2.0)
                .setSize(CGSize(width: 32, height: 32))
                .setBackgroundColors([ UIColor.systemBrown ])
                .build()
        return circleAvatarImage ?? UIImage(named: "AppIcon")!
    }
    
    func addSourceUserIcon(_ uid: String) -> some View {
        ZStack(alignment: .topLeading) {
            self
            Image(uiImage: userAvatar()).offset(x: 12, y: 12)
        }
    }
}

struct OrderListCell_Previews: PreviewProvider {
    static var previews: some View {
        OrderListCell(item: CartItem(foodName: "food", foodId: "12", foodPrice: 12, foodPic: "https://i.pinimg.com/236x/9a/32/50/9a3250ce0b20acb124664d6021a68e90.jpg", userId: "12", count: 2, sid: "12"))
    }
}
