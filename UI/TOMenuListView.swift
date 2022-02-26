//
//  TOMenuListView.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct TOMenuListView: View {
    let myList: [String] = ["1", "2"]//, "3","1", "2", "3","1", "2", "3","1", "2", "3","1", "2", "3"]
    let headerHeight = CGFloat(150)
    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]
    private var oneColumnGrid = [GridItem(.flexible())]
    private var twoColumnGrid = [GridItem(.flexible(),spacing: .menuListPadding),GridItem(.flexible(),spacing: .menuListPadding)]
    private var colors: [Color] = [.yellow, .purple, .green]
    
    private var placeholderFoods =  [TOFoodsItem]()
    private var placeholderCats = [TOFoodsCatItem]()
    
    // environment变量导致强制刷新
    // @ObservedObject变量不保存数据
    // 替换成stateobject
    @StateObject var viewModel = TOMenuListViewModel()
    //which cat is selected
    @State var selCatItemId: Int = 0
    
    init() {
        for one in 0...4 {
            placeholderFoods.append(TOFoodsItem(foodName: "chicken", foodPic: "image", foodId: 10 + one, foodPrice: 100))
            placeholderCats.append(TOFoodsCatItem(catgoryId: 20 + one, catgoryName: "cat", catgoryPic: "image", foods: []))
        }
        
        // environment之后改变
        // self.viewModel.isLoading = true
        // self.viewModel.getFoodsList()
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: twoColumnGrid,spacing: .menuListPadding,pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(self.viewModel.isLoading ? placeholderFoods : self.viewModel.foodList, id:\.foodId) { one in
                            TOMenuListCell(item: one)
                        }
                        .redacted(reason: self.viewModel.isLoading ? .placeholder : [])
                    } header: {
                        VStack(alignment:.leading) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: oneColumnGrid, spacing: .menuListCatgoryPadding) {
                                    // Display the item
                                    ForEach(self.viewModel.isLoading ? placeholderCats : self.viewModel.catList, id: \.catgoryId) {one in
                                        TOMenuCategoryCell(item:one, selItemId:$selCatItemId)
                                    }
                                    .redacted(reason: self.viewModel.isLoading ? .placeholder : [])
                                }
                            }
                            .frame(height: 110)
                            Text("Food List")
                                .font(.system(size: 24))
                                .frame(height: 40)
                        }
                        .frame(height: headerHeight)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                        .background(.white)
                        .onChange(of: selCatItemId) { newValue in
                            self.viewModel.switchCat(catId: newValue)
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: .menuListPadding, bottom: 0, trailing: .menuListPadding))
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
            }
        }
        .onAppear {
            // 本来已经放到init，毕竟init更像viewdidload
            // 但是environment变量强制刷，改进
            if viewModel.foodList.count <= 0 {
                self.viewModel.isLoading = true
                self.viewModel.getFoodsList()
            }
        }
    }
    
    struct TOMenuListView_Previews: PreviewProvider {
        static var previews: some View {
            TOMenuListView()
        }
    }
}
