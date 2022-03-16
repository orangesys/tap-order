//
//  TOCartCell.swift
//  TapOrder
//
//  Created by solo on 2/22/22.
//

import SwiftUI
import Kingfisher

struct TOCartCell: View {
    //var model = [TOCartItemForDel]()
    var item:TOCartItem
    var delId:String
    
    @EnvironmentObject var globalCart: TOCartViewModel

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
                            globalCart.removeFromCart(food: item)
                            //globalCart.newCartList = globalCart.newCartList.filter({$0.sid != item.sid})
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(item.userId != TOUserViewModel.shared.userid ? .gray : Color.normalRed)
                                .font(.system(size: 20))
                        }
                        .disabled( item.userId != TOUserViewModel.shared.userid)
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
                            globalCart.deleteFromCart(food: item)
//                            globalCart.newCartList = globalCart.newCartList.map({ one in
//                                var tmp = one
//                                if tmp.sid == item.sid {
//                                    tmp.count = tmp.count - 1
//                                }
//                                return tmp
//                            })
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundColor(item.userId != TOUserViewModel.shared.userid || (item.count <= 1) ? .gray : Color.themeColor)
                                .font(.system(size: 20))
                        }
                        .disabled( (item.userId != TOUserViewModel.shared.userid) || (item.count <= 1))
                        .buttonStyle(.borderless)
                        Text("\(item.count)")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.themeColor)
                        Button {
                            globalCart.addToCart(food: item)
//                            globalCart.newCartList = globalCart.newCartList.map({ one in
//                                var tmp = one
//                                if tmp.sid == item.sid {
//                                    tmp.count = tmp.count + 1
//                                }
//                                return tmp
//                            })
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(item.userId != TOUserViewModel.shared.userid ? .gray : Color.themeColor)
                                .font(.system(size: 20))
                        }
                        .disabled( item.userId != TOUserViewModel.shared.userid)
                        .buttonStyle(.borderless)//fix click issue
                    }
                }
            }
            .padding()
        }
        .background(item.userId != TOUserViewModel.shared.userid ? Color(uiColor: UIColor(rgb: 0xC7C7C7)).opacity(0.13) : Color.white)
        .cornerRadius(30)
    }
}

struct TOCartCell_Previews: PreviewProvider {
    static var previews: some View {
        TOCartCell(item: TOCartItem(foodName: "food", foodId: "12", foodPrice: 12, foodPic: "image", userId: "12", count: 2, sid: "12"), delId: "")
    }
}
