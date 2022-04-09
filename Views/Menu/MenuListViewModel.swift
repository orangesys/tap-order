//
//  MenuListViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Combine
import SwiftUI

// firebase api 版本
class MenuListViewModel: ObservableObject, APIService {
    var apiSession: APIProtocol
    var orginalList = [FoodsCatItem]()
    @Published var foodList = [FoodsItem]()
    @Published var catList = [FoodsCatItem]()
    @Published var isLoading = false

    var cancellables = Set<AnyCancellable>()
    
    init(apiSession: APIProtocol = APISession()) {
        self.apiSession = apiSession
    }
    
    func getFoodsList() {
        let cancellable = self.getFoodsList()
            .sink(receiveCompletion: { result in
                self.isLoading = false
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                
            }) { (rst) in
                var allFoods = [FoodsItem]()
                for one in rst.data {
                    allFoods.append(contentsOf: one.foods)
                }
                // insert all cat
                self.orginalList.append(FoodsCatItem(catgoryId: 0, catgoryName: "All", catgoryPic: "image", foods: allFoods))
                self.orginalList.append(contentsOf: rst.data)
                withAnimation {
                    self.foodList = allFoods
                    self.catList = self.orginalList
                }
                self.isLoading = false
        }
        cancellables.insert(cancellable)
    }
    
    func switchCat(catId:Int) {
        //var isAllCat = true
        var childFoods = [FoodsItem]()
        for one in orginalList {
            if one.catgoryId == catId {
                //isAllCat = false
                childFoods.append(contentsOf: one.foods)
                
                    self.foodList = childFoods
                
                break
            }
        }
    }
}
