//
//  VIPScheduleModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 04/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class VIPScheduleModel:Mappable
{
    
    
    var start:String?
    var date:String?
    var _id:String?
    var scheduletype:String?
    var id:Int?
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        start <- map["start_time"]
        _id <- map["_id"]
        scheduletype <- map["scheduletype"]
        date <- map["date"]
        id <- map["id"]
        
    }
    
    init() {
        
    }
    
}
