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
    var appointment:Array<AppointmentScheduleModel>?
    var vipSchedule:Array<VIPScheduleModel>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        scheduleData <- map["schedule"]
        appointment <- map["Appointment"]
        vipSchedule <- map["VIPSchedule"]
    }
    
    init() {
        
    }
    
}
