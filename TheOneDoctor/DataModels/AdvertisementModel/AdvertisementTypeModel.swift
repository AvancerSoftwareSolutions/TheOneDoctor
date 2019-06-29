//
//  AdvertisementTypeModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AdvertisementTypeModel:Mappable
{
    
    var id:Int?
    var name:String?
    var height:String?
    var width:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        height <- map["height"]
        width <- map["width"]
        
    }
    
    init() {
        
    }
    
}
