//
//  AppointmentScheduleModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 03/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AppointmentScheduleModel:Mappable
{
    
    
    var start:String?
    var timeslot:String?
    var date:String?
    var _id:String?
    var appointmentId:String?
    var id:Int?
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        start <- map["Start"]
        timeslot <- map["Timeslot"]
        _id <- map["_id"]
        appointmentId <- map["appointment_id"]
        date <- map["date"]
        id <- map["id"]
        
    }
    
    init() {
        
    }
    
}
