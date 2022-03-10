//
//  TOFoodViewModel.swift
//  TapOrder
//
//  Created by solo on 2022/3/8.
//

import Foundation
import Combine
import SwiftUI

class TOFoodViewModel: ObservableObject, TOAPIService {
    
    
    var apiSession: APIService
    var orginalList = [String:[TONewFoods]]()
    var allFoods = [TONewFoods]()
    @Published var foodList = [TONewFoods]()
    @Published var catList = [TONewFoodsCat]()
    @Published var isLoading = false

    var cancellables = Set<AnyCancellable>()
    
    let concurrentQueue = DispatchQueue(label:
                                 "com.oeoly.fetchqueue",
                                 attributes: .concurrent)
                                 
    let concurrentFetchGroup = DispatchGroup()
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
    }
    
    func getFoodsCat() {
        let cancellable = self.getFoodsCat()
            .sink(receiveCompletion: { result in
                // self.isLoading = false
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                
            }) { (rst) in
                
                // cats
                self.catList = Array(rst.values)
                self.catList.insert(TONewFoodsCat(), at: 0)
                for one in rst {
                    // enter group request
                    self.concurrentFetchGroup.enter()
                    // use id for key
                    self.orginalList[one.value.id!.uuidString] = [TONewFoods]()
                    self.concurrentQueue.async {
                        let cancellable2 = self.getFoodsCatList(cat: one.key)
                            .sink(receiveCompletion: { result in
                                print("completion \(one.key)")
                                self.concurrentFetchGroup.leave()
                                switch result {
                                case .failure(let error):
                                    print("Handle error: \(error)")
                                case .finished:
                                    break
                                }
                                
                            }) { (foods) in
                                print("success \(one.key)")
                                var configFoodsArr = [TONewFoods]()
                                for var oneFood in foods {
                                    oneFood.value.id = oneFood.key
                                    configFoodsArr.append(oneFood.value)
                                }
                                DispatchQueue.main.async {
                                    self.orginalList[one.key] = configFoodsArr
                                    self.allFoods.append(contentsOf: configFoodsArr)
                                }
                        }
                        DispatchQueue.main.async {
                            self.cancellables.insert(cancellable2)
                        }
                    }
                    
                    // back
                    self.concurrentFetchGroup.notify(queue: DispatchQueue.main) {
                        self.orginalList[self.catList.first?.id?.uuidString ?? "01"] = self.allFoods
                        self.isLoading = false
                        self.foodList = self.allFoods
                    }
                }
        }
        cancellables.insert(cancellable)
    }
    
    // not use now
    func getFoodsCatList(cat:String) {
        let cancellable = self.getFoodsCatList(cat: cat)
            .sink(receiveCompletion: { result in
                self.isLoading = false
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                
            }) { (rst) in
                _ = [TOFoodsItem]()
        }
        cancellables.insert(cancellable)
    }
    
    func switchCat(catId:String) {
        //var isAllCat = true
        self.foodList = orginalList[catId]!
    }
}
