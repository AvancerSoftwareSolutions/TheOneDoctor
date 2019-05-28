//
//  ScheduleDateModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ScheduleDateModel:Mappable
{
    
    var status:StatusDataModel?
    var startTime:String?
    var endTime:String?
    var interval:String?
    var fees:Float?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        startTime <- map["StartTime"]
        endTime <- map["EndTime"]
        interval <- map["Interval"]
        fees <- map["fees"]
        
    }
    
    init() {
        
    }
    
}
