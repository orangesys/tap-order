//
//  CartCell.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI
import Kingfisher

struct CartCell: View {
    //var model = [CartItemForDel]()
    var item:CartItem
    var delId:String
    
    @EnvironmentObject var globalCart: CartViewModel

    var body: some View {
        VStack {
            HStack {
                KFImage.url(URL(string: item.foodPic))
                    .placeholder{Image("chicken").resizable()}
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
                        Button {
                            globalCart.updateFoodInCart(item, action: .remove)
                            //globalCart.newCartList = globalCart.newCartList.filter({$0.sid != item.sid})
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(item.userId != UserViewModel.shared.userid ? .gray : Color.normalRed)
                                .font(.system(size: 20))
                        }
                        .disabled( item.userId != UserViewModel.shared.userid)
                        .buttonStyle(.borderless)//fix click issue

                    }
                    Text("\(item.foodPrice)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.normalYellow)
                    HStack {
                        Button {
                            print(item.count)
                            if item.count <= 1 {
                                return
                            }
                            globalCart.updateFoodInCart(item, action: .subtractOne)
//                            globalCart.newCartList = globalCart.newCartList.map({ one in
//                                var tmp = one
//                                if tmp.sid == item.sid {
//                                    tmp.count = tmp.count - 1
//                                }
//                                return tmp
//                            })
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundColor(item.userId != UserViewModel.shared.userid || (item.count <= 1) ? .gray : Color.themeColor)
                                .font(.system(size: 20))
                        }
                        .disabled( (item.userId != UserViewModel.shared.userid) || (item.count <= 1))
                        .buttonStyle(.borderless)
                        Text("\(item.count)")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.themeColor)
                        Button {
                            globalCart.updateFoodInCart(item, action: .plusOne)
//                            globalCart.newCartList = globalCart.newCartList.map({ one in
//                                var tmp = one
//                                if tmp.sid == item.sid {
//                                    tmp.count = tmp.count + 1
//                                }
//                                return tmp
//                            })
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(item.userId != UserViewModel.shared.userid ? .gray : Color.themeColor)
                                .font(.system(size: 20))
                        }
                        .disabled( item.userId != UserViewModel.shared.userid)
                        .buttonStyle(.borderless)//fix click issue
                    }
                }
            }
            .padding()
        }
        .background(item.userId != UserViewModel.shared.userid ? Color(uiColor: UIColor(rgb: 0xC7C7C7)).opacity(0.13) : Color.white)
        .cornerRadius(30)
    }
}

struct CartCell_Previews: PreviewProvider {
    static var previews: some View {
        CartCell(item: CartItem(foodName: "food", foodId: "12", foodPrice: 12, foodPic: "image", userId: "12", count: 2, sid: "12"), delId: "")
    }
}
