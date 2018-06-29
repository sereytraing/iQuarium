//
//  Fish.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 29/06/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import ObjectMapper

class Fish : Mappable{
    var name: String?
    //var species: Specie?
    var aquarium: Aquarium?
    var owner: User?
    var height: Double?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        //species <- map["Species"]
        aquarium <- map["Aquarium"]
        owner <- map["Owner"]
        height <- map["height"]
    }
}