//
//  SessionScheduleDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class SessionScheduleDataModel:Mappable
{
    
    var railwayformat:String?
    var ordinaryformat:String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        railwayformat <- map["24format"]
        ordinaryformat <- map["12format"]
        
    }
    
    init() {
        
    }
    
}
