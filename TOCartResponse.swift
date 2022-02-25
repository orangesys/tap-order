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
    let foodName: String
    let foodId: Int
    let foodPrice: Double
    let foodPic: String
    let createAt: Date
    let userId: String
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
