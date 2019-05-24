//
//  AddScheduleModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 23/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AddScheduleModel:Mappable
{
    
    var status:StatusDataModel?
    var scheduleData:Array<AddScheduleDataModel>?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        scheduleData <- map["schedule"]
    }
    
    init() {
        
    }
    
}
