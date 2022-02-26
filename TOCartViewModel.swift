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
    
    @Published var cartList =  [[TOCartItemForDel]]() // extraordinary
    @Published var badgeNum = 0
    @Published var isLoading = false
    @Published var isError = false
    @Published var totalStr = ""
    var errorStr = ""
    var isBackgroundLoading = false

    var cancellables = Set<AnyCancellable>()
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
    }
    
    func postCart(item:TOCartItemSend) {
        let cancellable = self.postCart(cartSend: item)
            .sink(receiveCompletion: { result in
                
                self.getCartList2()
                
                switch result {
                case .failure(let error):
                    self.isError = true
                    self.errorStr = "\(error)"
                    print("Handle error: \(error)")
                case .finished:
                    print("finish: ")
                    break
                }
                
            }) { (rst) in
                self.isLoading = true // 还要fetch
        }
        cancellables.insert(cancellable)
    }
    
    func delCart(delId:String) {
        let cancellable = self.delCart(delId: delId)
            .sink(receiveCompletion: { result in
                
                self.getCartList2()
                
                switch result {
                case .failure(let error):
                    self.isError = true
                    self.errorStr = "\(error)"
                    print("Handle error: \(error)")
                case .finished:
                    print("finish: ")
                    break
                }
                
            }) { (rst) in
                self.isLoading = true // 还要fetch
        }
        cancellables.insert(cancellable)
    }

    func getCartList2() {
        let cancellable = self.getCartList2()
            .sink(receiveCompletion: { result in
                self.isLoading = false
                self.isBackgroundLoading = false
                switch result {
                case .failure(let error):
                    self.isError = true
                    self.errorStr = "\(error)"
                    print("Handle error: \(error)")
                case .finished:
                    print("finish: ")
                    break
                }
                
            }) { (rst) in
                self.badgeNum = rst.count
                var tmp = [TOCartItemForDel]()
                var totoalNum = 0.0
                for delId in rst.keys {
                    tmp.append(TOCartItemForDel(item: rst[delId]!, delId: delId))
                    totoalNum = totoalNum + rst[delId]!.foodPrice
                }
                let groupUserDic = Dictionary(grouping: tmp) { $0.item.userId}
                // this will generate array[(key,value)]
                let sortedGroupUserDic = groupUserDic.sorted {$0.key < $1.key}
                let valuesArraySorted = Array(sortedGroupUserDic.map({ $0.value }))
                var groupFoodArr = [[TOCartItemForDel]]()
                for arr in valuesArraySorted {
                    let groupFoodDic = Dictionary(grouping: arr) { $0.item.foodId}
                    let sortedGroupFood = groupFoodDic.sorted {$0.key < $1.key}
                    let foodArraySorted = Array(sortedGroupFood.map({ $0.value }))
                    groupFoodArr.append(contentsOf: foodArraySorted )
                    
                }
                //withAnimation {
                    self.totalStr = totoalNum.round2Str()
                    self.cartList = groupFoodArr
                //}
                self.isLoading = false
                self.isBackgroundLoading = false
        }
        cancellables.insert(cancellable)
    }
}
