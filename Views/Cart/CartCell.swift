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
    var item: CartItem
    var delId: String
    
    @EnvironmentObject var globalCart: CartViewModel

    var body: some View {
        VStack {
            HStack {
                CartImages(orderImageURLString:  item.foodPic, userImageURLString: item.userId)
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

struct CartImages: View {
    let orderImageURLString: String
    let userImageURLString: String
    
    @State var useUserImageAsItem: Bool = false
    
    var body: some View {
        KFImage(URL(string: (useUserImageAsItem ? orderImageURLString : userImageURLString))).onFailure({ _ in
            useUserImageAsItem = true
        })
            .resizable()
            .scaledToFit()
    }
}


struct CartCell_Previews: PreviewProvider {
    static var previews: some View {
        CartCell(item: CartItem(foodName: "food",
                                foodId: "12",
                                foodPrice: 12,
                                foodPic: "https://i.pinimg.cm/236x/9a/32/50/9a3250ce0b20acb124664d6021a68e90.jpg",
                                userId: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQEB3Y66JcK_cgf1bCVn1a0JUhbUU7_GMlvA&usqp=CAU",
                                count: 2,
                                sid: "12"), delId: "")
    }
}
