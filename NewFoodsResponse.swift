//
//  NewFoodsResponse.swift
//  TapOrder
//
//  Created by solo on 2022/3/8.
//

import Foundation

struct NewFoodsCat: Codable, Identifiable, Equatable {
    // let id: UUID?
    var id: String?
    var name: String?
    var image: String?
    var activate: Bool?

    //init(id: UUID = UUID(), name: String = "All", activate: Bool = true, image: String = "kicten") {
    init(name: String = "All", activate: Bool = true, image: String = "kicten") {
        //self.id = id
        self.id = name
        self.name = name
        self.image = image
        self.activate = activate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        id = try values.decodeIfPresent(String.self, forKey: .name) ?? "id"
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        activate = try values.decodeIfPresent(Bool.self, forKey: .activate)
    }

    static let KeyForUserDefaults = "keyNewFoodsCat_\(UserViewModel.shared.lang)"

    static func save(_ cats: [NewFoodsCat]) {
        if needUpdate(cats){
            let data = cats.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: "keyNewFoodsCat_\(UserViewModel.shared.lang)")
        }
    }
    
    static func needUpdate(_ cats: [NewFoodsCat]) -> Bool{
        let oldArr = load()
        let changes = cats.difference(from: oldArr)
        if !changes.isEmpty {
            let data = cats.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: "keyNewFoodsCat_\(UserViewModel.shared.lang)")
        }
        return !changes.isEmpty
    }

    static func load() -> [NewFoodsCat] {
        guard let encodedData = UserDefaults.standard.array(forKey: "keyNewFoodsCat_\(UserViewModel.shared.lang)") as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(NewFoodsCat.self, from: $0) }
    }
}

struct NewFoods: Codable, Identifiable, Equatable {
    var id: String?
    var name: String?
    var image: String?
    var price: String?
    var customer_id: String?
    var count: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id = "sku_id"
        case name
        case image
        case customer_id
        case price
        case count
    }
    
    static let KeyForUserDefaults = "keyTONewFoods"
    
    static func needUpdate(_ cats: [NewFoods], cat:String) -> Bool{
        let oldArr = load(cat)
        let changes = cats.difference(from: oldArr)
        print("ssn save:\(cat)_\("KeyForUserDefaults")")
        if !changes.isEmpty {
            let data = cats.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: "\(cat)_\("KeyForUserDefaults")".encodeBase64()!)
        }
        return !changes.isEmpty
    }

    static func save(_ cats: [NewFoods], cat:String) {
        let data = cats.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: "\(cat)_\("KeyForUserDefaults")".encodeBase64()!)
    }

    static func load(_ cat:String) -> [NewFoods] {
        print("ssn load:\(cat)_\("KeyForUserDefaults")")
        guard let encodedData = UserDefaults.standard.array(forKey: "\(cat)_\("KeyForUserDefaults")".encodeBase64()!) as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(NewFoods.self, from: $0) }
    }
}
