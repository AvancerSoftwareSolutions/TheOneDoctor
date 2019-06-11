//
//  RescheduleDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class RescheduleDataModel:Mappable
{
    
    var time:String?
    var from:String?
    var status:Int?
    var type:String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        time <- map["TIME"]
        from <- map["From"]
        status <- map["Status"]
        type <- map["Type"]
    }
    
    init() {
        
    }
    
}
