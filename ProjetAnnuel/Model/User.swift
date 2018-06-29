//
//  User.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 29/06/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import ObjectMapper

class User : Mappable{
    var username: String?
    var id: String?
    var fishes: [Fish]?
    var aquariums: [Aquarium]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        id <- map["_id"]
        fishes <- map["Fishes"]
        aquariums <- map["Aquariums"]
    }
}
