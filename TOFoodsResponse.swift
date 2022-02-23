//
//  TOFoodsResponse.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/23/22.
//

import Foundation

struct TOFoodsResposne: Codable {
    let code: Int

    let data: [TOFoodsResposneItem]
    let err: String
    let msg: String
}

struct TOFoodsResposneItem: Codable,Identifiable {
    let id = UUID()
    let catgoryName: String
    let catgoryPic: String
    struct Foods: Codable {
        let foodName: String
        let foodPic: String
        let foodPrice: String
    }
    let foods: [Foods]
}
