//
//  Aquarium.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 29/06/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import ObjectMapper

class Aquarium : Mappable{
    var id: String?
    var name: String?
    var pictures: [String]?
    var temperatureReal: Double?
    var temperatureWanted: Double?
    var volume: Double?
    var isDirty: Bool?
    var fishes: [Fish]?
    var owner: User?
    var foodConfiguration: FoodConfiguration?
    var isFavorite: Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        pictures <- map["pictures"]
        temperatureReal <- map["realTemp"]
        temperatureWanted <- map["intentedTemp"]
        volume <- map["volume"]
        isDirty <- map["isDirty"]
        fishes <- map["Fishes"]
        owner <- map["Owner"]
        foodConfiguration <- map["FoodConfiguration"]
        isFavorite <- map["isFavorite"]
        
    }
}
