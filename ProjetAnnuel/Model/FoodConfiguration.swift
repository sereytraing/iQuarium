//
//  FoodConfiguration.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 08/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import ObjectMapper

class FoodConfiguration : Mappable{
    var cycle: Int?
    var distribution: [String]?
    var hasFood: Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        cycle <- map["cycle"]
        distribution <- map["distribution"]
        hasFood <- map["hasFood"]
    }
}
