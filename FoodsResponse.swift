//
//  FoodsResponse.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation

struct FoodsResposne: Codable {
    let code: Int
    let err: String
    
    let data: [FoodsCatItem]
    let msg: String
}

struct FoodsCatItem: Codable {
    let catgoryId: Int
    let catgoryName: String
    let catgoryPic: String
    
    let foods: [FoodsItem]
}

struct FoodsItem: Codable {
    let foodName: String
    let foodPic: String
    let foodId: Int
    let foodPrice: Double
}
