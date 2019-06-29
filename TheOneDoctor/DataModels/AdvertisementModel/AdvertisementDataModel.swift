//
//  AdvertisementDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AdvertisementDataModel:Mappable
{
    
    var id:Int?
    var date:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        date <- map["date"]
        
    }
    
    init() {
        
    }
    
}
