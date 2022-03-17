//
//  MenuListCell.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI
import Kingfisher

struct MenuListCell: View , Equatable{
    var imgName = "chicken"
    var catName = "chicken\nbugger"
    var priceName = "20"
    
    var item:NewFoods
    
    @EnvironmentObject var globalCart: CartViewModel

    var body: some View {
        
       return VStack {
           KFImage(URL(string:item.image ?? "chicken"))
                .resizable()
                .scaledToFit()
                .font(.system(size: 30))
                .frame(width: .MenuCardWidth - 20, height: 65)
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
                    globalCart.sendToCart(food: item)
                    //self.globalCart.badgeNum = self.globalCart.badgeNum + 1
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
    
    static func == (lhs: MenuListCell, rhs: MenuListCell) -> Bool {
        return lhs.item.id == rhs.item.id && lhs.item.name == rhs.item.name
    }
}

struct MenuListCell_Previews: PreviewProvider {
    static var previews: some View {
        MenuListCell(item: NewFoods(id: "123", name: "name"))
    }
}
