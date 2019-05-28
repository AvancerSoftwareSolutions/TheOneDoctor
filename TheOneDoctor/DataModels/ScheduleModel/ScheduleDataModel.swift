//
//  ScheduleDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 24/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ScheduleDataModel:Mappable
{
    
    var dateDict:Dictionary<String,Any>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        dateDict <- map["Date"]
    }
    
    init() {
        
    }
    
}
