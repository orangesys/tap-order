//
//  TONewFoodsResponse.swift
//  TapOrder
//
//  Created by solo on 2022/3/8.
//

import Foundation

struct TONewFoodsCat: Codable, Identifiable, Equatable {
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

    static let KeyForUserDefaults = "keyTONewFoodsCat_\(TOUserViewModel.shared.lang)"

    static func save(_ cats: [TONewFoodsCat]) {
        if needUpdate(cats){
            let data = cats.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: "keyTONewFoodsCat_\(TOUserViewModel.shared.lang)")
        }
    }
    
    static func needUpdate(_ cats: [TONewFoodsCat]) -> Bool{
        let oldArr = load()
        let changes = cats.difference(from: oldArr)
        if !changes.isEmpty {
            let data = cats.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: "keyTONewFoodsCat_\(TOUserViewModel.shared.lang)")
        }
        return !changes.isEmpty
    }

    static func load() -> [TONewFoodsCat] {
        guard let encodedData = UserDefaults.standard.array(forKey: "keyTONewFoodsCat_\(TOUserViewModel.shared.lang)") as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(TONewFoodsCat.self, from: $0) }
    }
}

struct TONewFoods: Codable, Identifiable, Equatable {
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
    
    static func needUpdate(_ cats: [TONewFoods], cat:String) -> Bool{
        let oldArr = load(cat)
        let changes = cats.difference(from: oldArr)
        print("ssn save:\(cat)_\("KeyForUserDefaults")")
        if !changes.isEmpty {
            let data = cats.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: "\(cat)_\("KeyForUserDefaults")".encodeBase64()!)
        }
        return !changes.isEmpty
    }

    static func save(_ cats: [TONewFoods], cat:String) {
        let data = cats.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: "\(cat)_\("KeyForUserDefaults")".encodeBase64()!)
    }

    static func load(_ cat:String) -> [TONewFoods] {
        print("ssn load:\(cat)_\("KeyForUserDefaults")")
        guard let encodedData = UserDefaults.standard.array(forKey: "\(cat)_\("KeyForUserDefaults")".encodeBase64()!) as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(TONewFoods.self, from: $0) }
    }
}
