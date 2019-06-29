//
//  ScheduleHistoryModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ScheduleHistoryModel:Mappable
{
    
    var status:StatusDataModel?
    var appointment:Array<ScheduleHistoryDataModel>?
    var totalAppointment:Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        appointment <- map["Appointment"]
        totalAppointment <- map["TotalAppointment"]
        // TotalAppointment
    }
    
    init() {
        
    }
    
}
