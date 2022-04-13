//
//  CartResponse.swift
//  TapOrder (iOS)
//
//  Created by solo on 2/25/22.
//

import Foundation

struct CartResponse: Codable {
    let items: [String: CartItem]
    let total: Int
}

struct CartSendOrder: Codable {
    let uuid: String
}

struct CartItem: Codable {
    let foodName: String
    let foodId: String
    let foodPrice: Int
    let foodPic: String
    // let createAt: Date
    let userId: String
    var count: Int
    let sid: String

    enum CodingKeys: String, CodingKey {
        case foodName = "name"
        case foodPrice = "price"
        case foodPic = "image"
        case foodId = "sku_id"
        case count
        case userId = "customer_id"
        case sid = "uuid"
    }
}

extension CartItem {
    // [A Workaround for a Missing Memberwise Initializer](https://cocoacasts.com/swift-fundamentals-what-is-a-memberwise-initializer)
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sid = try values.decodeIfPresent(String.self, forKey: .sid) ?? "sid"
        foodName = try values.decodeIfPresent(String.self, forKey: .foodName) ?? "name"
        foodId = try values.decodeIfPresent(String.self, forKey: .foodId) ?? "foodId"
        userId = try values.decodeIfPresent(String.self, forKey: .userId) ?? "userId"
        foodPic = try values.decodeIfPresent(String.self, forKey: .foodPic) ?? "foodPic"
        foodPrice = try values.decodeIfPresent(Int.self, forKey: .foodPrice) ?? 0
        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? 0
    }

    // init(from decoder: Decoder) throws {
    //     let values = try decoder.container(keyedBy: CodingKeys.self)
    //     sid = try values.decodeIfPresent(UUID.self, forKey: .sid) ?? UUID() //json have not this key
    //     foodName = try values.decodeIfPresent(String.self, forKey: .foodName) ?? "name"
    //     foodId = try values.decodeIfPresent(String.self, forKey: .foodId) ?? "foodId"
    //     userId = try values.decodeIfPresent(String.self, forKey: .userId) ?? "userId"
    //     foodPic = try values.decodeIfPresent(String.self, forKey: .foodPic) ?? "foodPic"
    //     foodPrice = try values.decodeIfPresent(Int.self, forKey: .foodPrice) ?? 0
    //     count = try values.decodeIfPresent(Int.self, forKey: .count) ?? 0
    // }
}

struct CartItemForDel {
    let item: CartItem
    var delId: String? // 为了firebase的删除
}

struct CartItemSend: Codable {
    let foodName: String
    let foodId: Int
    let foodPrice: Double
    let foodPic: String
    let createAt: [String: String] // [".sv":"timestamp"]
    let userId: String
}

// struct CartResponse: Codable {
//    let orderId: String
//    struct OrderList: Codable {
//        let birthday: String
//        let createAt: Date
//        let name: String
//    }
//    let orderList: [OrderList]
// }
