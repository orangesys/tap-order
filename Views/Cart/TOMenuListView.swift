//
//  TOMenuListView.swift
//  TapOrder
//
//  Created by solo on 2/21/22.
//

import SwiftUI

struct MenuListView: View {
    let headerHeight = CGFloat(150)
    private var oneColumnGrid = [GridItem(.flexible())]
    private var twoColumnGrid = [GridItem(.flexible(),spacing: .menuListPadding),GridItem(.flexible(),spacing: .menuListPadding)]
    
    private var placeholderFoods =  [TONewFoods]()
    private var placeholderCats = [TONewFoodsCat]()
    
    @State var isLoading = false
    @Binding var isSwitch:Bool
    
    // environment变量导致强制刷新
    // @ObservedObject变量不保存数据
    // 替换成stateobject
    @StateObject var viewModel = TOFoodViewModel()
    //which cat is selected
    @State var selCatItemId: String = "All"
    
    init(isSwitch: Binding<Bool>) {
        self._isSwitch = isSwitch
        for one in 0...4 {
            placeholderFoods.append(TONewFoods(id: "\(one)", name: "name"))
            placeholderCats.append(TONewFoodsCat(name: "name", activate: true))
        }
        // environment之后改变
        // self.viewModel.isLoading = true
        // self.viewModel.getFoodsList()
    }
    
    var body: some View {
        Self._printChanges()
        return ZStack {
            RefreshableScrollView(refreshing: .constant(viewModel.isLoading)) {
                LazyVGrid(columns: twoColumnGrid,spacing: .menuListPadding,pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(self.viewModel.isLoading ? placeholderFoods : self.viewModel.foodList, id:\.id) { one in
                            MenuListCell(item: one)//.equatable()
                        }
                        .redacted(reason: self.viewModel.isLoading ? .placeholder : [])
                    } header: {
                        VStack(alignment:.leading) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: oneColumnGrid, spacing: .menuListCatgoryPadding) {
                                    // Display the item
                                    ForEach(self.viewModel.isLoading ? placeholderCats : self.viewModel.catList, id: \.id) {one in
                                        MenuCategoryCell(item:one, selItemId:$selCatItemId)
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
            
           // another loading style
           //
           // if viewModel.isLoading {
           //     ProgressView()
           //         .padding()
           //         .background(Color.white)
           //         .cornerRadius(20)
           //         .shadow(radius: 20)
           // }
        }
        .onAppear {
            let oldCats = TONewFoodsCat.load()
            if oldCats.count > 0 {
                self.viewModel.catList = oldCats
            } else {
                if !self.viewModel.isLoading {
                    self.viewModel.isLoading = true
                    self.viewModel.getFoodsCat()
                }
            }
            let oldFoods = TONewFoods.load((oldCats.first?.name ?? "ssn"))
            if oldFoods.count > 0 {
                self.viewModel.foodList = oldFoods
            } else {
                if !self.viewModel.isLoading {
                    self.viewModel.isLoading = true
                    self.viewModel.getFoodsCat()
                }
            }
            // 本来已经放到init，毕竟init更像viewdidload
            // 但是environment变量强制刷，改进
            if (viewModel.foodList.count <= 0 && self.viewModel.isLoading == false){
            //    self.viewModel.isLoading = true
                //self.isLoading = viewModel.isLoading
                self.viewModel.getFoodsCat()
            }
        }
        .onChange(of: self.isSwitch) { newValue in
            if newValue {
//                self.viewModel.isLoading = true
//                self.viewModel.getFoodsCat()
                self.isSwitch = false
                
                viewModel.restoreOriginalList()
                let oldCats = TONewFoodsCat.load()
                if oldCats.count > 0 {
                    self.viewModel.catList = oldCats
                } else {
                    if !self.viewModel.isLoading {
                        self.viewModel.isLoading = true
                        self.viewModel.getFoodsCat()
                    }
                }
                let oldFoods = TONewFoods.load((oldCats.first?.name ?? "ssn"))
                if oldFoods.count > 0 {
                    self.viewModel.foodList = oldFoods
                } else {
                    if !self.viewModel.isLoading {
                        self.viewModel.isLoading = true
                        self.viewModel.getFoodsCat()
                    }
                }
                // 本来已经放到init，毕竟init更像viewdidload
                // 但是environment变量强制刷，改进
                if (viewModel.foodList.count <= 0 && self.viewModel.isLoading == false){
                //    self.viewModel.isLoading = true
                    //self.isLoading = viewModel.isLoading
                    self.viewModel.getFoodsCat()
                }
            }
        }
    }
    
    struct TOMenuListView_Previews: PreviewProvider {
        static var previews: some View {
            MenuListView(isSwitch: .constant(false))
        }
    }
}
