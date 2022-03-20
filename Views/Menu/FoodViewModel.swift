//
//  FoodViewModel.swift
//  TapOrder
//
//  Created by solo on 2022/3/8.
//

import Foundation
import Combine
import SwiftUI

class FoodViewModel: ObservableObject, APIService {
    var apiSession: APIProtocol
    var orginalList = [String:[NewFoods]]()
    var allFoods = [NewFoods]()
    @Published var foodList = [NewFoods]()
    @Published var catList = [NewFoodsCat]()
    @Published var isLoading = false
    @Published var allCatId = ""

    var cancellables = Set<AnyCancellable>()
    
    let concurrentQueue = DispatchQueue(label:
                                 "com.oeoly.fetchqueue",
                                 attributes: .concurrent)
                                 
    let concurrentFetchGroup = DispatchGroup()
    
    init(apiSession: APIProtocol = APISession()) {
        self.apiSession = apiSession
        self.restoreOriginalList()
    }
    
    func restoreOriginalList() {
        let oldCats = NewFoodsCat.load()
        for cat in oldCats {
            self.orginalList[cat.name] = NewFoods.load(cat.name)
        }
    }
    
    func getFoodsCat() {
        orginalList.removeAll()
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
                
                let sortRst = rst.sorted{$0.value.name > $1.value.name}
                // cats
                let ctsArr =  Array(rst.values).sorted{$0.name > $1.name}
                self.getFoodsCatList(cat: sortRst.first!.key, name: (ctsArr.first?.name)! )
                if NewFoodsCat.needUpdate(ctsArr) {
                    self.catList = ctsArr
                }
                //sortRst.remove(at: 0)
                //self.catList.insert(NewFoodsCat(), at: 0)
                for one in sortRst {
                    // enter group request
                    self.concurrentFetchGroup.enter()
                    // use id for key
                    self.orginalList[one.value.id] = [NewFoods]()
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
                                var configFoodsArr = [NewFoods]()
                                for var oneFood in foods {
                                    oneFood.value.id = oneFood.key
                                    configFoodsArr.append(oneFood.value)
                                }
                                DispatchQueue.main.async {
                                    let newArr = configFoodsArr.sorted{$0.id! > $1.id!}
                                    if NewFoods.needUpdate(newArr, cat: one.value.id) {
                                        self.orginalList[one.value.id] = newArr
                                    }
                                }
                        }
                        DispatchQueue.main.async {
                            self.cancellables.insert(cancellable2)
                        }
                    }

                    // back
                    self.concurrentFetchGroup.notify(queue: DispatchQueue.main) {
                        //self.allCatId = self.catList.first?.id?.uuidString ?? "ALL"
                        //self.orginalList[self.catList.first?.id?.uuidString ?? "01"] = self.allFoods
                        self.isLoading = false
                        //self.foodList = self.orginalList[ctsArr.first?.id ?? "01"]!
                        //self.foodList = self.allFoods
                    }
                }
        }
        cancellables.insert(cancellable)
    }
    
    // not use now
    // cat 是key，name是存储的key
    func getFoodsCatList(cat:String, name:String) {
        let cancellable = self.getFoodsCatList(cat: cat)
            .sink(receiveCompletion: { result in
                self.isLoading = false
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                
            }) { (foods) in
                print("first success \(cat)")
                var configFoodsArr = [NewFoods]()
                for var oneFood in foods {
                    oneFood.value.id = oneFood.key
                    configFoodsArr.append(oneFood.value)
                }
                DispatchQueue.main.async {
                    let newArr = configFoodsArr.sorted{$0.id! > $1.id!}
                    if NewFoods.needUpdate(newArr, cat: name) {
                        self.orginalList[name] = newArr
                        self.foodList = self.orginalList[name]!
                    }
                    self.isLoading = false
                }
        }
        cancellables.insert(cancellable)
    }
    
    func switchCat(catId:String) {
        //var isAllCat = true
        self.foodList = orginalList[catId]!
    }
    
    
}
