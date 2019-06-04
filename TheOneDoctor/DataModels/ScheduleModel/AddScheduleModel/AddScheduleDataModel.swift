//
//  AddScheduleDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 23/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AddScheduleDataModel:Mappable
{
    
    var doctorId:Int?
    var availableDays:String?
    var startTime:String?
    var endTime:String?
    var patientHrsTime:String?
    var deleteStatus:Int?
    var type:String?
    var id:Int?
    var scheduleId:Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        doctorId <- map["doctor_id"]
        availableDays <- map["available_days"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
        patientHrsTime <- map["per_patient_time"]
        deleteStatus <- map["deleted_status"]
        type <- map["type"]
        id <- map["s_id"]
        scheduleId <- map["schedule_id"]
    }
    
    init() {
        
    }
    
}
