//
//  SessionScheduleModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class SessionScheduleModel:Mappable
{
    
    var status:StatusDataModel?
    var sessionData:Array<SessionScheduleDataModel>?
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        sessionData <- map["data"]
        
    }
    
    init() {
        
    }
    
}
