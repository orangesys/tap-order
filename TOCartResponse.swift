//
//  TOCartResponse.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/25/22.
//

import Foundation

//struct TOCartResponse: Codable {
//    let foodName: String
//    let foodPic: String
//    let foodId: Int
//    let foodPrice: Double
//    let foodCount: Int?
//    let userId: String
//    let createAt: Date
//}

struct TOCartItem: Codable {
    let foodName: String?
    let foodId: String
    let foodPrice: Int
    let foodPic: String
    //let createAt: Date
    let userId: String
    let count: Int
    let sid: UUID?

    enum CodingKeys: String, CodingKey {
        case foodName = "name"
        case foodPrice = "price"
        case foodPic = "image"
        case foodId = "sku_id"
        case count = "count"
        case userId = "customer_id"
        case sid = "sid"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sid = try values.decodeIfPresent(UUID.self, forKey: .sid) ?? UUID()
        foodName = try values.decodeIfPresent(String.self, forKey: .foodName) ?? "name"
        foodId = try values.decodeIfPresent(String.self, forKey: .foodId) ?? "foodId"
        userId = try values.decodeIfPresent(String.self, forKey: .userId) ?? "userId"
        foodPic = try values.decodeIfPresent(String.self, forKey: .foodPic) ?? "foodPic"
        foodPrice = try values.decodeIfPresent(Int.self, forKey: .foodPrice) ?? 0
        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? 0
    }
}

struct TOCartItemForDel {
    let item: TOCartItem
    var delId: String? // 为了firebase的删除
}

struct TOCartItemSend: Codable {
    let foodName: String
    let foodId: Int
    let foodPrice: Double
    let foodPic: String
    let createAt: [String:String] //[".sv":"timestamp"]
    let userId: String
}

struct TOCartResponse: Codable {
    let orderId: String
    struct OrderList: Codable {
        let birthday: String
        let createAt: Date
        let name: String
    }
    let orderList: [OrderList]
}
