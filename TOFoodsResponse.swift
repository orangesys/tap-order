//
//  TOFoodsResponse.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation

struct TOFoodsResposne: Codable {
    let code: Int
    let err: String
    
    let data: [TOFoodsCatItem]
    let msg: String
}

struct TOFoodsCatItem: Codable {
    let catgoryId: Int
    let catgoryName: String
    let catgoryPic: String
    
    let foods: [TOFoodsItem]
}

struct TOFoodsItem: Codable {
    let foodName: String
    let foodPic: String
    let foodId: Int
    let foodPrice: Double
}
