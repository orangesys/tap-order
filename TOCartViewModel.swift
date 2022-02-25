//
//  TOCartViewModel.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/24/22.
//

import Foundation
import Combine
import SwiftUI

class TOCartViewModel: ObservableObject, TOAPIService {
    
    var apiSession: APIService
    
    @Published var cartList = [TOFoodsItem]()
    @Published var isLoading = false

    var cancellables = Set<AnyCancellable>()
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
    }
    
    func getCartList() {
        let cancellable = self.getCartList()
            .sink(receiveCompletion: { result in
                self.isLoading = false
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                
            }) { (rst) in
//                var allFoods = [TOFoodsItem]()
//                for one in rst.data {
//                    allFoods.append(contentsOf: one.foods)
//                }
//                // insert all cat
//                self.orginalList.append(TOFoodsCatItem(catgoryId: 0, catgoryName: "All", catgoryPic: "image", foods: allFoods))
//                self.orginalList.append(contentsOf: rst.data)
//                withAnimation {
//                    self.foodList = allFoods
//                    self.catList = self.orginalList
//                }
                self.isLoading = false
        }
        cancellables.insert(cancellable)
    }
    
    func getCartList2() {
        let cancellable = self.getCartList2()
            .sink(receiveCompletion: { result in
                self.isLoading = false
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                
            }) { (rst) in
//                var allFoods = [TOFoodsItem]()
//                for one in rst.data {
//                    allFoods.append(contentsOf: one.foods)
//                }
//                // insert all cat
//                self.orginalList.append(TOFoodsCatItem(catgoryId: 0, catgoryName: "All", catgoryPic: "image", foods: allFoods))
//                self.orginalList.append(contentsOf: rst.data)
//                withAnimation {
//                    self.foodList = allFoods
//                    self.catList = self.orginalList
//                }
                self.isLoading = false
        }
        cancellables.insert(cancellable)
    }
}
