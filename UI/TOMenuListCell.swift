//
//  TOMenuListCell.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct TOMenuListCell: View {
    var imgName = "chicken"
    var catName = "chicken\nbugger"
    var priceName = "20"
    
    var item:TONewFoods
    var socket:WebSocketStream
    
    @EnvironmentObject var globalCart: TOCartViewModel

    var body: some View {
        
        VStack {
            Image("\(imgName)")
                .resizable()
                .scaledToFit()
                .font(.system(size: 30))
                .frame(width: .TOMenuCardWidth - 20, height: 65)
                //.background(Color.themeColor)
                .cornerRadius(20)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            Text(item.name ?? "name")
                .font(.system(size: 20))
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height:50)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            HStack {
                Text( item.price ?? "0.0" )
                    .font(.system(size: 18,weight: .bold))
                .foregroundColor(Color(uiColor: UIColor(rgb: 0xCAAA38)))
                Spacer()
                Button {
                    socket.sendToCart(food: item)
                    self.globalCart.badgeNum = self.globalCart.badgeNum + 1
                    //self.globalCart.postCart(item: TOCartItemSend(foodName: item.foodName, foodId: item.foodId, foodPrice: item.foodPrice, foodPic: item.foodPic, createAt: [".sv": "timestamp"], userId: TOUserViewModel.shared.userid))
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.normalGreen)
                        .font(.system(size: 25))
                }

            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
        }
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .top)
        .background(LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(rgb: 0xe8e8e8)), Color(uiColor:UIColor(rgb: 0xe4e4e4).withAlphaComponent(0.85))]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
    }
}

struct TOMenuListCell_Previews: PreviewProvider {
    static var previews: some View {
        TOMenuListCell(item: TONewFoods(id: "123", name: "name"), socket: WebSocketStream(url: ""))
    }
}
