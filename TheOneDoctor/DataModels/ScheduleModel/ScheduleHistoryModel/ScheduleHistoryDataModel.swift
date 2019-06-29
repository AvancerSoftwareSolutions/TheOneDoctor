//
//  ScheduleHistoryDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ScheduleHistoryDataModel:Mappable
{
    
    
    var month:String?
    var value:Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        month <- map["month"]
        value <- map["value"]
        
    }
    
    init() {
        
    }
    
}
