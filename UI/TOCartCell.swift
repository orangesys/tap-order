//
//  TOCartCell.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI

struct TOCartCell: View {
    var model = [TOCartItemForDel]()
    var item:TOCartItem
    var delId:String 
    
    @EnvironmentObject var globalCart: TOCartViewModel

    var body: some View {
        VStack {
            HStack {
                Image("chicken")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 130, alignment: .center)
                    .background(Color.normalGray)
                    .cornerRadius(20)
                VStack(alignment:.leading,spacing: 15){
                    HStack {
                        Text("\(item.foodName)")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color.normalRed)
                                .font(.system(size: 20))
                        }
                        .disabled( item.userId != TOUserViewModel.shared.userid)

                    }
                    Text(item.foodPrice.round2Str() )
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.normalYellow)
                    HStack {
                        Button {
                            self.globalCart.delCart(delId: delId)
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundColor(item.userId != TOUserViewModel.shared.userid ? .gray : Color.themeColor)
                                .font(.system(size: 20))
                        }
                        .disabled( item.userId != TOUserViewModel.shared.userid)
                        .buttonStyle(.borderless)
                        Text("\(model.count)")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.themeColor)
                        Button {
                            self.globalCart.postCart(item: TOCartItemSend(foodName: item.foodName, foodId: item.foodId, foodPrice: item.foodPrice, foodPic: item.foodPic, createAt: [".sv": "timestamp"], userId: TOUserViewModel.shared.userid))
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(item.userId != TOUserViewModel.shared.userid ? .gray : Color.themeColor)
                                .font(.system(size: 20))
                        }
                        .disabled( item.userId != TOUserViewModel.shared.userid)
                        .buttonStyle(.borderless)
                    }
                }
            }
            .padding()
        }
        .background(item.userId != TOUserViewModel.shared.userid ? Color(uiColor: UIColor(rgb: 0xC7C7C7)).opacity(0.13) : Color.white)
        .cornerRadius(30)
    }
}

//struct TOCartCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TOCartCell()
//    }
//}
