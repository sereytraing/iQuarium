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
    var name: String?
    var picture: [String]?
    var temperature: Double?
    var volume: Double?
    var isDirty: Bool?
    var fishes: [Fish]?
    var owner: User?
    //var foodConfiguration: FoodConfiguration?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        picture <- map["picture"]
        temperature <- map["temperature"]
        volume <- map["volume"]
        isDirty <- map["isDirty"]
        fishes <- map["Fishes"]
        owner <- map["Owner"]
        //foodConfiguration <- map["FoodConfiguration"]
        
    }
}
