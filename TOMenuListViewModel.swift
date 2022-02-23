//
//  TOMenuListViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation
import Combine
import SwiftUI

class TOMenuListViewModel: ObservableObject, TOAPIService {
    var apiSession: APIService
    var orginalList = [TOFoodsCatItem]()
    @Published var foodList = [TOFoodsItem]()
    @Published var catList = [TOFoodsCatItem]()

    var cancellables = Set<AnyCancellable>()
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
    }
    
    func getFoodsList() {
        let cancellable = self.getFoodsList()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                
            }) { (rst) in
                var allFoods = [TOFoodsItem]()
                for one in rst.data {
                    allFoods.append(contentsOf: one.foods)
                }
                self.foodList = allFoods
                // insert all cat
                self.orginalList.append(TOFoodsCatItem(catgoryId: 0, catgoryName: "All", catgoryPic: "image", foods: allFoods))
                self.orginalList.append(contentsOf: rst.data)
                self.catList = self.orginalList
        }
        cancellables.insert(cancellable)
    }
    
    func switchCat(catId:Int) {
        //var isAllCat = true
        var childFoods = [TOFoodsItem]()
        for one in orginalList {
            if one.catgoryId == catId {
                //isAllCat = false
                childFoods.append(contentsOf: one.foods)
                self.foodList = childFoods
                break
            }
        }
//        if childFoods.count == 0 {
//            var allFoods = [TOFoodsItem]()
//            for one in orginalList {
//                allFoods.append(contentsOf: one.foods)
//            }
//            self.foodList = allFoods
//        } else {
//            self.foodList = childFoods
//        }
    }
}
