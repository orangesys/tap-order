//
//  TONewFoodsResponse.swift
//  TapOrder
//
//  Created by solo on 2022/3/8.
//

import Foundation

struct TONewFoodsCat: Codable, Identifiable {
    let id: UUID?
    var name: String?
    var activate: Bool?

    init(id: UUID = UUID(), name: String = "All", activate: Bool = true) {
        self.id = id
        self.name = name
        self.activate = activate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try values.decodeIfPresent(String.self, forKey: .name)
        activate = try values.decodeIfPresent(Bool.self, forKey: .activate)
    }

}

struct TONewFoods: Codable, Identifiable {
    var id: String?
    var name: String?
    var image: String?
    var price: String?

    init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}
