//
//  Species.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import ObjectMapper

class Species : Mappable{
    var scientificName: String?
    var commonNames: [String]?
    var rarety: String?
    var volumeMin: Int?
    var zone: [String]?
    var phMin: Double?
    var phMax: Double?
    var temperatureMin: Double?
    var temperatureMax: Double?
    var diet: String?
    var pictures: [String]?
    var id: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        scientificName <- map["scientificName"]
        commonNames <- map["commonNames"]
        rarety <- map["rarety"]
        volumeMin <- map["volumeMin"]
        zone <- map["zone"]
        phMin <- map["PHMin"]
        phMax <- map["PHMax"]
        temperatureMin <- map["temperatureMin"]
        temperatureMax <- map["temperatureMax"]
        diet <- map["diet"]
        pictures <- map["pictures"]
    }
}
